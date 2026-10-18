; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module main: the interactive flow. Greets, explains how to answer, asks the questions one by one,
; repeats a question until the answer is valid, then prints the scores and the verdict.
; Written by Claude; checked by `barthelona verify`.
; QUESTIONS and LINE_CAP must equal the consts in contracts.yaml (issue #122: gen/*.inc cannot be included yet).
bits 64
default rel

QUESTIONS equ 12
LINE_CAP equ 16

global _start
extern input_read_line
extern input_classify
extern quiz_question
extern quiz_dimension
extern quiz_temperament
extern quiz_name
extern quiz_meaning
extern render_text
extern render_number

section .rodata
str_intro:
    db "=== Опросник темперамента ===", 10
    db "Это короткий тест из 12 вопросов. Он оценивает два свойства по методике Айзенка:", 10
    db "общительность (экстраверсию) и эмоциональную неустойчивость (нейротизм).", 10
    db "Результат - ориентир, а не диагноз.", 10, 10
    db "Как отвечать: на каждый вопрос введите д (да) или н (нет) и нажмите Enter.", 10
    db "Подойдут также y/n, да/нет и 1/0. Думайте недолго: первый ответ обычно самый честный.", 10
    db "Чтобы выйти раньше, нажмите Ctrl+D.", 10, 10, 0
str_head:   db "Вопрос ", 0
str_of:     db " из 12", 10, 0
str_prompt: db "Ваш ответ (д/н): ", 0
str_retry:  db "Не понял ответ. Введите д или н (можно также y/n или 1/0).", 10, 0
str_abort:  db 10, "Ввод закончился раньше времени, опросник прерван.", 10, 0
str_res_e:  db 10, "Результат", 10, "Общительность (экстраверсия): ", 0
str_res_n:  db " из 6", 10, "Эмоциональная неустойчивость (нейротизм): ", 0
str_res_t:  db " из 6", 10, 10, "Ваш темперамент: ", 0
str_newline: db 10, 0
str_outro:  db 10, "Это ориентир, а не диагноз. Чтобы пройти тест ещё раз, запустите программу снова.", 10, 0

section .bss
line_buf:   resb LINE_CAP

section .text

; Registers kept across calls (the callees never touch them): r12 question index, r13 extraversion
; "yes" count, r14 neuroticism "yes" count, r15 temperament. rsp is 16-byte aligned at every call.
_start:
    lea rdi, [str_intro]
    call render_text
    xor r12d, r12d
    xor r13d, r13d
    xor r14d, r14d
.ask:
    cmp r12d, QUESTIONS
    jae .result
    lea rdi, [str_head]
    call render_text
    lea rdi, [r12 + 1]
    call render_number
    lea rdi, [str_of]
    call render_text
    mov rdi, r12
    call quiz_question
    mov rdi, rax
    call render_text
.prompt:
    lea rdi, [str_prompt]
    call render_text
    lea rdi, [line_buf]
    mov esi, LINE_CAP
    call input_read_line
    cmp rax, -1
    je .eof
    mov rdi, rax
    mov rsi, [line_buf]
    call input_classify
    cmp eax, 1
    je .yes
    cmp eax, 2
    je .next
    lea rdi, [str_retry]
    call render_text
    jmp .prompt
.yes:
    mov rdi, r12
    call quiz_dimension
    test eax, eax
    jnz .neuro
    inc r13d
    jmp .next
.neuro:
    inc r14d
.next:
    inc r12d
    jmp .ask
.result:
    lea rdi, [str_res_e]
    call render_text
    mov rdi, r13
    call render_number
    lea rdi, [str_res_n]
    call render_text
    mov rdi, r14
    call render_number
    lea rdi, [str_res_t]
    call render_text
    mov rdi, r13
    mov rsi, r14
    call quiz_temperament
    mov r15, rax
    mov rdi, r15
    call quiz_name
    mov rdi, rax
    call render_text
    lea rdi, [str_newline]
    call render_text
    mov rdi, r15
    call quiz_meaning
    mov rdi, rax
    call render_text
    lea rdi, [str_newline]
    call render_text
    lea rdi, [str_outro]
    call render_text
    xor edi, edi
    jmp .exit
.eof:
    lea rdi, [str_abort]
    call render_text
    mov edi, 1
.exit:
    mov eax, 60                 ; SYS_exit(status in edi)
    syscall

section .note.GNU-stack noalloc noexec nowrite progbits
