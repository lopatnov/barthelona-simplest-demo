; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module input: reads the move script from stdin and maps keys to directions.
; Written by Claude (the engine does not exist yet); checked by `barthelona verify`.
bits 64
default rel

global input_read_moves
global input_dir_of

section .text

; input_read_moves(rdi = buf, rsi = capacity) -> rax = bytes read
; Reads stdin until EOF, an error, or the buffer is full (bounded by capacity).
input_read_moves:
    mov r8, rdi                 ; buffer start
    mov r9, rsi                 ; bytes still allowed
    xor r10d, r10d              ; bytes read so far
.read:
    test r9, r9
    jz .done
    xor eax, eax                ; SYS_read
    xor edi, edi                ; fd 0
    lea rsi, [r8 + r10]
    mov rdx, r9
    syscall
    test rax, rax
    jle .done                   ; 0 = EOF, negative = error
    add r10, rax
    sub r9, rax
    jmp .read
.done:
    mov rax, r10
    ret

; input_dir_of(dil = key) -> rax = 0 up, 1 right, 2 down, 3 left, or -1 for any other key
; Keys are w d s a, in either case.
input_dir_of:
    movzx eax, dil
    or eax, 0x20                ; fold upper case to lower case
    cmp eax, 'w'
    je .up
    cmp eax, 'd'
    je .right
    cmp eax, 's'
    je .down
    cmp eax, 'a'
    je .left
    mov rax, -1
    ret
.up:
    xor eax, eax
    ret
.right:
    mov eax, 1
    ret
.down:
    mov eax, 2
    ret
.left:
    mov eax, 3
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
