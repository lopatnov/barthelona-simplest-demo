; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module input: reads one answer line from stdin and decides whether it means yes, no or neither.
; Written by Claude; checked by `barthelona verify`.
; ACCEPTED must equal the number of entries in each of the two tables below.
bits 64
default rel

ACCEPTED equ 11                 ; words per table

global input_read_line
global input_classify

section .rodata
; Words are compared as little-endian qwords, so "да" is the UTF-8 bytes D0 B4 D0 B0 read as one number.
yes_words:  dq 'д', 'Д', 'да', 'Да', 'ДА', 'y', 'Y', 'yes', 'Yes', 'YES', '1'
no_words:   dq 'н', 'Н', 'нет', 'Нет', 'НЕТ', 'n', 'N', 'no', 'No', 'NO', '0'

section .bss
char_buf:   resb 1

section .text

; input_read_line(rdi = buffer, rsi = capacity) -> rax = bytes stored, or -1 at EOF with nothing read.
; Reads up to the next newline. CR, space and tab are dropped; bytes beyond the capacity are skipped.
input_read_line:
    mov r8, rdi
    mov r9, rsi
    xor r10d, r10d              ; bytes stored so far
.next:
    xor eax, eax                ; SYS_read(0, char_buf, 1)
    xor edi, edi
    lea rsi, [char_buf]
    mov edx, 1
    syscall
    test rax, rax
    jle .eof                    ; 0 is EOF; a negative errno is treated the same way
    movzx eax, byte [char_buf]
    cmp al, 10
    je .done
    cmp al, 13
    je .next
    cmp al, 32
    je .next
    cmp al, 9
    je .next
    cmp r10, r9
    jae .next                   ; line longer than the buffer: drop the rest
    mov [r8 + r10], al
    inc r10
    jmp .next
.eof:
    test r10, r10
    jnz .done                   ; last line had no newline
    mov rax, -1
    ret
.done:
    mov rax, r10
    ret

; input_classify(rdi = line length, rsi = first 8 bytes of the line) -> rax: 0 not an answer, 1 yes, 2 no.
; Bytes past the length are masked off, so stale buffer contents never matter.
input_classify:
    xor eax, eax
    cmp rdi, 8
    jae .ret                    ; no accepted word is that long
    lea ecx, [rdi * 8]
    mov rdx, 1
    shl rdx, cl
    dec rdx                     ; mask of the first <length> bytes
    and rsi, rdx
    lea r8, [yes_words]
    xor ecx, ecx
.scan:
    cmp rsi, [r8 + rcx * 8]
    je .yes
    cmp rsi, [r8 + rcx * 8 + ACCEPTED * 8]
    je .no
    inc ecx
    cmp ecx, ACCEPTED
    jb .scan
.ret:
    ret
.yes:
    mov eax, 1
    ret
.no:
    mov eax, 2
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
