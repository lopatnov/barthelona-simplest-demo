; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module game: Snake rules and state. No I/O. Written by Claude; see tools/reference.py
; for the Python model that produces the golden outputs.
; BOARD_W / BOARD_H must equal the consts in contracts.yaml (issue #122: gen/*.inc cannot be included yet).
bits 64
default rel

BOARD_W    equ 16
BOARD_H    equ 8
RING_MASK  equ 127              ; the snake is a ring buffer of 128 cells
SEED       equ 12345
TRIES      equ 4096             ; bound on the food placement loop

global game_init
global game_step
global game_cell
global game_score
global game_alive

section .rodata
dx_table: db 0, 1, 0, -1        ; up, right, down, left
dy_table: db -1, 0, 1, 0

section .bss
snake_x:  resb 128
snake_y:  resb 128
head_idx: resq 1
length:   resq 1
heading:  resq 1
food_x:   resq 1
food_y:   resq 1
score:    resq 1
dead:     resq 1
rng:      resq 1

section .text

; game_init(): snake of 3 cells heading right, score 0, first food from the seeded generator
game_init:
    mov byte [snake_x + 0], 6
    mov byte [snake_y + 0], 4
    mov byte [snake_x + 1], 7
    mov byte [snake_y + 1], 4
    mov byte [snake_x + 2], 8
    mov byte [snake_y + 2], 4
    mov qword [head_idx], 2
    mov qword [length], 3
    mov qword [heading], 1
    mov qword [score], 0
    mov qword [dead], 0
    mov qword [rng], SEED
    sub rsp, 8                  ; keep rsp 16-byte aligned at the call
    call place_food
    add rsp, 8
    ret

; game_step(rdi = direction 0..3) -> rax = 0 moved, 1 ate, 2 died, 3 ignored (already dead)
; A turn straight back onto the neck is ignored and the snake keeps its heading.
game_step:
    push rbx
    cmp qword [dead], 0
    jne .ignored
    and edi, 3
    mov rax, [heading]
    lea rcx, [rax + 2]
    and ecx, 3
    cmp rdi, rcx
    jne .turn_ok
    mov rdi, rax                ; reversal: keep going
.turn_ok:
    mov [heading], rdi
    mov rcx, [head_idx]
    lea r8, [snake_x]
    lea r9, [snake_y]
    movzx eax, byte [r8 + rcx]
    movzx edx, byte [r9 + rcx]
    lea r10, [dx_table]
    movsx r11d, byte [r10 + rdi]
    add eax, r11d
    lea r10, [dy_table]
    movsx r11d, byte [r10 + rdi]
    add edx, r11d
    cmp eax, BOARD_W            ; unsigned compare also catches -1
    jae .die
    cmp edx, BOARD_H
    jae .die
    xor ebx, ebx                ; ebx = 1 when the new head lands on the food
    cmp qword [length], 127
    jae .check
    cmp rax, [food_x]
    jne .check
    cmp rdx, [food_y]
    jne .check
    mov ebx, 1
.check:
    mov rcx, [length]           ; the tail cell is free again unless the snake grows
    dec rcx
    add rcx, rbx
    mov edi, eax
    mov esi, edx
    mov rdx, rcx
    call hits_snake
    test eax, eax
    jnz .die
    mov rcx, [head_idx]
    inc rcx
    and rcx, RING_MASK
    mov [head_idx], rcx
    lea r8, [snake_x]
    mov [r8 + rcx], dil
    lea r8, [snake_y]
    mov [r8 + rcx], sil
    test ebx, ebx
    jz .moved
    inc qword [length]
    inc qword [score]
    call place_food
    mov eax, 1
    pop rbx
    ret
.moved:
    xor eax, eax
    pop rbx
    ret
.die:
    mov qword [dead], 1
    mov eax, 2
    pop rbx
    ret
.ignored:
    mov eax, 3
    pop rbx
    ret

; game_cell(edi = x, esi = y) -> rax = 0 empty, 1 head, 2 body, 3 food, 4 head of a dead snake
game_cell:
    mov rcx, [head_idx]
    lea r8, [snake_x]
    lea r9, [snake_y]
    movzx eax, byte [r8 + rcx]
    cmp eax, edi
    jne .body
    movzx eax, byte [r9 + rcx]
    cmp eax, esi
    jne .body
    mov eax, 1
    cmp qword [dead], 0
    je .out
    mov eax, 4
.out:
    ret
.body:
    mov rdx, [length]
    sub rsp, 8
    call hits_snake
    add rsp, 8
    test eax, eax
    jz .food
    mov eax, 2
    ret
.food:
    mov eax, edi
    cmp rax, [food_x]
    jne .empty
    mov eax, esi
    cmp rax, [food_y]
    jne .empty
    mov eax, 3
    ret
.empty:
    xor eax, eax
    ret

; game_score() -> rax = foods eaten
game_score:
    mov rax, [score]
    ret

; game_alive() -> rax = 1 while the snake lives, else 0
game_alive:
    xor eax, eax
    cmp qword [dead], 0
    sete al
    ret

; hits_snake(edi = x, esi = y, rdx = count) -> eax = 1 when one of the first `count` segments
; (head first) is at (x, y). Leaf routine; clobbers rcx, rdx, r8, r9, r10.
hits_snake:
    mov rcx, [head_idx]
    lea r8, [snake_x]
    lea r9, [snake_y]
    xor eax, eax
.loop:
    test rdx, rdx
    jz .done
    movzx r10d, byte [r8 + rcx]
    cmp r10d, edi
    jne .next
    movzx r10d, byte [r9 + rcx]
    cmp r10d, esi
    jne .next
    mov eax, 1
    ret
.next:
    dec rcx
    and rcx, RING_MASK
    dec rdx
    jmp .loop
.done:
    ret

; place_food(): next food cell from the LCG, redrawn while it lies on the snake.
; After TRIES draws the food is parked off the board at (255, 255) so the loop stays bounded.
place_food:
    push rbx
    mov ebx, TRIES
.retry:
    dec ebx
    jz .park
    mov rax, [rng]
    imul rax, rax, 1103515245
    add rax, 12345
    and rax, 0x7fffffff
    mov [rng], rax
    shr rax, 16
    xor edx, edx
    mov ecx, BOARD_W
    div rcx
    mov r11, rdx                ; x
    mov rax, [rng]
    shr rax, 8
    xor edx, edx
    mov ecx, BOARD_H
    div rcx
    mov esi, edx                ; y
    mov edi, r11d
    mov rdx, [length]
    call hits_snake
    test eax, eax
    jnz .retry
    mov [food_x], r11
    mov eax, esi
    mov [food_y], rax
    pop rbx
    ret
.park:
    mov qword [food_x], 255
    mov qword [food_y], 255
    pop rbx
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
