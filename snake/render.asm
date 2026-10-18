; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module render: draws the board and the status line on stdout. Reads the game only through game_cell,
; game_score and game_alive. Written by Claude; checked by `barthelona verify`.
; BOARD_W / BOARD_H must equal the consts in contracts.yaml (issue #122: gen/*.inc cannot be included yet).
bits 64
default rel

BOARD_W equ 16
BOARD_H equ 8

global render_board
global render_status
extern game_cell
extern game_score
extern game_alive

section .rodata
glyphs:     db ' ', 'O', 'o', '*', 'X'     ; indexed by game_cell: empty head body food dead head
str_score:  db 'SCORE '
str_alive:  db 10, 'ALIVE', 10
str_dead:   db 10, 'GAME OVER', 10

section .bss
board_buf:  resb 256
status_buf: resb 64
digit_buf:  resb 24

section .text

; render_board(): one write() with the framed board, one row per line
render_board:
    push rbx                    ; y
    push r12                    ; x
    push r13                    ; write pointer
    push r14                    ; start of the buffer
    sub rsp, 8                  ; four pushes + return address leave rsp 8 off 16
    lea r14, [board_buf]
    mov r13, r14
    call emit_border
    xor ebx, ebx
.row:
    mov byte [r13], '|'
    inc r13
    xor r12d, r12d
.col:
    mov edi, r12d
    mov esi, ebx
    call game_cell
    lea rcx, [glyphs]
    mov al, [rcx + rax]
    mov [r13], al
    inc r13
    inc r12d
    cmp r12d, BOARD_W
    jb .col
    mov byte [r13], '|'
    mov byte [r13 + 1], 10
    add r13, 2
    inc ebx
    cmp ebx, BOARD_H
    jb .row
    call emit_border
    mov eax, 1                  ; SYS_write
    mov edi, 1
    mov rsi, r14
    mov rdx, r13
    sub rdx, r14
    syscall
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; emit_border: appends +----------------+ and a newline at r13 (leaf; clobbers ecx)
emit_border:
    mov byte [r13], '+'
    inc r13
    mov ecx, BOARD_W
.dash:
    mov byte [r13], '-'
    inc r13
    dec ecx
    jnz .dash
    mov byte [r13], '+'
    mov byte [r13 + 1], 10
    add r13, 2
    ret

; render_status(): "SCORE <n>" then "ALIVE" or "GAME OVER", in one write()
render_status:
    push rbx
    call game_score
    mov r8, rax
    lea rdi, [status_buf]
    lea rsi, [str_score]
    mov ecx, 6
    rep movsb
    lea r9, [digit_buf + 24]    ; digits are produced backwards
    mov r10d, 10
    mov rax, r8
.digit:
    xor edx, edx
    div r10
    add dl, '0'
    dec r9
    mov [r9], dl
    test rax, rax
    jnz .digit
    lea rcx, [digit_buf + 24]
    sub rcx, r9
    mov rsi, r9
    rep movsb
    mov rbx, rdi                ; game_alive may clobber rdi
    call game_alive
    mov rdi, rbx
    lea rsi, [str_alive]
    mov ecx, 7
    test eax, eax
    jnz .copy
    lea rsi, [str_dead]
    mov ecx, 11
.copy:
    rep movsb
    lea rsi, [status_buf]
    mov rdx, rdi
    sub rdx, rsi
    mov eax, 1
    mov edi, 1
    syscall
    pop rbx
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
