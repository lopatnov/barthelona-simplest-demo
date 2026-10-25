section .data
    q1  db "Q1/12: Do you enjoy meeting new people? (y/n): "
    q1_len equ $ - q1
    q2  db "Q2/12: Do you suffer from 'nerves'? (y/n): "
    q2_len equ $ - q2
    q3  db "Q3/12: Are you usually carefree? (y/n): "
    q3_len equ $ - q3
    q4  db "Q4/12: Do you often feel lonely? (y/n): "
    q4_len equ $ - q4
    q5  db "Q5/12: Do you like going out a lot? (y/n): "
    q5_len equ $ - q5
    q6  db "Q6/12: Are you often troubled by feelings of guilt? (y/n): "
    q6_len equ $ - q6
    q7  db "Q7/12: Can you easily get some life into a dull party? (y/n): "
    q7_len equ $ - q7
    q8  db "Q8/12: Do you often worry about things you should not have done? (y/n): "
    q8_len equ $ - q8
    q9  db "Q9/12: Are you mostly quiet when with others? (y/n): "
    q9_len equ $ - q9
    q10 db "Q10/12: Are you easily hurt when people find fault with you? (y/n): "
    q10_len equ $ - q10
    q11 db "Q11/12: Do you tend to keep in the background on social occasions? (y/n): "
    q11_len equ $ - q11
    q12 db "Q12/12: Do you often feel 'fed up'? (y/n): "
    q12_len equ $ - q12

    questions dq q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12
    qlengths  dq q1_len, q2_len, q3_len, q4_len, q5_len, q6_len, q7_len, q8_len, q9_len, q10_len, q11_len, q12_len

    newline db 0x0A
    newline_len equ $ - newline

    extra_str db "Extraversion: "
    extra_str_len equ $ - extra_str
    neuro_str db "Neuroticism: "
    neuro_str_len equ $ - neuro_str
    temp_str db "Temperament: "
    temp_str_len equ $ - temp_str

    sanguine  db "Sanguine", 0x0A
    sanguine_len equ $ - sanguine
    choleric  db "Choleric", 0x0A
    choleric_len equ $ - choleric
    phlegmatic db "Phlegmatic", 0x0A
    phlegmatic_len equ $ - phlegmatic
    melancholic db "Melancholic", 0x0A
    melancholic_len equ $ - melancholic

section .bss
    answer_buf resb 1
    digit_buf  resb 1

section .text
    global _start

_start:
    xor rbx, rbx        ; extraversion score (callee-saved)
    xor r15, r15        ; neuroticism score (callee-saved)
    xor r12, r12        ; question index 0-11 (callee-saved)

question_loop:
    ; print question
    mov rax, 1
    mov rdi, 1
    mov rsi, [questions + r12*8]
    mov rdx, [qlengths + r12*8]
    syscall

    ; read one line (byte by byte until newline or EOF)
    xor r13, r13        ; flag: have we stored first char?
    xor r14, r14        ; store first char here
.read_loop:
    mov rax, 0
    mov rdi, 0
    mov rsi, answer_buf
    mov rdx, 1
    syscall
    test rax, rax
    jz .read_done       ; EOF
    cmp byte [answer_buf], 0x0A
    je .read_done       ; newline
    test r13, r13
    jnz .read_loop      ; already have first char, keep reading
    mov r14b, [answer_buf]
    mov r13, 1
    jmp .read_loop
.read_done:
    ; r14b holds first char (or 0 if empty line/EOF)
    test r13, r13
    jz answer_no        ; empty line or EOF -> no
    cmp r14b, 'y'
    je answer_yes
    cmp r14b, 'Y'
    je answer_yes

answer_no:
    jmp next_question

answer_yes:
    test r12, 1
    jz extraversion_yes
    inc r15             ; neuroticism uses r15 (callee-saved)
    jmp next_question

extraversion_yes:
    inc rbx

next_question:
    inc r12
    cmp r12, 12
    jl question_loop

    ; save scores before printing
    mov r13, rbx
    mov r14, r15

    ; blank line after last answer
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    ; Extraversion: <digit>
    mov rax, 1
    mov rdi, 1
    mov rsi, extra_str
    mov rdx, extra_str_len
    syscall

    mov al, r13b
    add al, '0'
    mov [digit_buf], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit_buf
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    ; Neuroticism: <digit>
    mov rax, 1
    mov rdi, 1
    mov rsi, neuro_str
    mov rdx, neuro_str_len
    syscall

    mov al, r14b
    add al, '0'
    mov [digit_buf], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit_buf
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    ; Temperament: <name>
    mov rax, 1
    mov rdi, 1
    mov rsi, temp_str
    mov rdx, temp_str_len
    syscall

    cmp r13, 4
    jge check_neuro_high
    ; E < 4
    cmp r14, 4
    jge melancholic_case
    jmp phlegmatic_case

check_neuro_high:
    ; E >= 4
    cmp r14, 4
    jge choleric_case
    jmp sanguine_case

sanguine_case:
    mov rax, 1
    mov rdi, 1
    mov rsi, sanguine
    mov rdx, sanguine_len
    syscall
    jmp exit_program

choleric_case:
    mov rax, 1
    mov rdi, 1
    mov rsi, choleric
    mov rdx, choleric_len
    syscall
    jmp exit_program

melancholic_case:
    mov rax, 1
    mov rdi, 1
    mov rsi, melancholic
    mov rdx, melancholic_len
    syscall
    jmp exit_program

phlegmatic_case:
    mov rax, 1
    mov rdi, 1
    mov rsi, phlegmatic
    mov rdx, phlegmatic_len
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
