; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module main: replays the move script from stdin, then prints the final board and score.
; Keys w a s d move the snake one cell per key; other bytes are ignored. Written by Claude.
bits 64
default rel

MAX_MOVES equ 4096

global _start
extern game_init
extern game_step
extern input_read_moves
extern input_dir_of
extern render_board
extern render_status

section .bss
moves: resb MAX_MOVES

section .text

_start:                         ; rsp is 16-byte aligned here, so every call below is aligned
    call game_init
    lea rdi, [moves]
    mov esi, MAX_MOVES
    call input_read_moves
    mov r12, rax                ; number of keys read
    xor ebx, ebx                ; index of the next key
.next:
    cmp rbx, r12
    jae .render
    lea rax, [moves]
    movzx edi, byte [rax + rbx]
    inc rbx
    call input_dir_of
    test rax, rax
    js .next                    ; not a movement key
    mov rdi, rax
    call game_step
    jmp .next
.render:
    call render_board
    call render_status
    xor edi, edi                ; exit(0)
    mov eax, 60
    syscall

section .note.GNU-stack noalloc noexec nowrite progbits
