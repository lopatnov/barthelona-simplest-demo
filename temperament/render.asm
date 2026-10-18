; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module render: writes text and numbers to stdout. Written by Claude; checked by `barthelona verify`.
bits 64
default rel

global render_text
global render_number

section .bss
digit_buf:  resb 24

section .text

; render_text(rdi = zero-terminated string): one write() of the whole string
render_text:
    mov rsi, rdi
    xor edx, edx
.len:
    cmp byte [rsi + rdx], 0
    je .write
    inc rdx
    jmp .len
.write:
    mov eax, 1                  ; SYS_write(1, string, length)
    mov edi, 1
    syscall
    ret

; render_number(rdi = unsigned number): its decimal digits, no newline
render_number:
    lea r9, [digit_buf + 24]    ; digits are produced backwards
    mov r10d, 10
    mov rax, rdi
.digit:
    xor edx, edx
    div r10
    add dl, '0'
    dec r9
    mov [r9], dl
    test rax, rax
    jnz .digit
    lea rdx, [digit_buf + 24]
    sub rdx, r9
    mov rsi, r9
    mov eax, 1
    mov edi, 1
    syscall
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
