; dialect=nasm preset=linux-x64-nasm-static expect=V6:pass
; Module quiz: the questions, the scoring rule and the verdict texts. No I/O.
; Written by Claude; checked by `barthelona verify`.
; QUESTIONS and HIGH_AT must equal the consts in contracts.yaml (issue #122: gen/*.inc cannot be included yet).
bits 64
default rel

QUESTIONS equ 12
VERDICTS equ 4
HIGH_AT equ 4                   ; "yes" answers (of 6) from which a dimension counts as high

global quiz_question
global quiz_dimension
global quiz_temperament
global quiz_name
global quiz_meaning

section .rodata
question_table: dq q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12
name_table:     dq name_sanguine, name_choleric, name_phlegmatic, name_melancholic
meaning_table:  dq mean_sanguine, mean_choleric, mean_phlegmatic, mean_melancholic

; Even-numbered (0-based) questions measure extraversion, odd ones neuroticism.
q01: db "Вы легко знакомитесь с новыми людьми?", 10, 0
q02: db "Ваше настроение часто меняется без видимой причины?", 10, 0
q03: db "Вам нравятся шумные вечеринки и большие компании?", 10, 0
q04: db "Вы долго переживаете после неприятного разговора?", 10, 0
q05: db "Вы обычно первым начинаете разговор?", 10, 0
q06: db "Вы часто волнуетесь по пустякам?", 10, 0
q07: db "Вам трудно усидеть на месте, когда вокруг ничего не происходит?", 10, 0
q08: db "Вам трудно успокоиться, когда что-то пошло не так?", 10, 0
q09: db "Вы быстро заводите друзей и охотно делитесь планами?", 10, 0
q10: db "Вы нередко чувствуете себя виноватым без серьёзных причин?", 10, 0
q11: db "Вы любите быть в центре внимания?", 10, 0
q12: db "Вы остро реагируете на критику?", 10, 0

name_sanguine:    db "САНГВИНИК", 0
name_choleric:    db "ХОЛЕРИК", 0
name_phlegmatic:  db "ФЛЕГМАТИК", 0
name_melancholic: db "МЕЛАНХОЛИК", 0

mean_sanguine:    db "Общительный, живой и уравновешенный. Быстро находит общий язык, легко переносит неудачи и "
                  db "переключается на новое. Слабая сторона - непостоянство и нехватка усидчивости.", 0
mean_choleric:    db "Общительный, энергичный и эмоционально возбудимый. Горит идеями и действует напористо, но бывает "
                  db "вспыльчив и нетерпелив. Помогает привычка делать паузу, прежде чем ответить.", 0
mean_phlegmatic:  db "Спокойный, уравновешенный и сдержанный. Работает ровно и надёжно, не теряет головы в трудную минуту. "
                  db "Слабая сторона - медлительность и неохота к переменам.", 0
mean_melancholic: db "Чувствительный, вдумчивый и склонный к тревоге. Глубоко переживает и тонко замечает детали, но быстро "
                  db "устаёт и сомневается в себе. Помогают поддержка близких и чёткий распорядок.", 0

section .text

; quiz_question(rdi = index below QUESTIONS) -> rax = zero-terminated question text, or 0 when out of range
quiz_question:
    lea rax, [question_table]
    mov ecx, QUESTIONS
    jmp pick

; quiz_name(rdi = temperament 0..3) -> rax = zero-terminated name, or 0 when out of range
quiz_name:
    lea rax, [name_table]
    mov ecx, VERDICTS
    jmp pick

; quiz_meaning(rdi = temperament 0..3) -> rax = zero-terminated description, or 0 when out of range
quiz_meaning:
    lea rax, [meaning_table]
    mov ecx, VERDICTS
    jmp pick

; pick: rax = pointer table, rdi = index, ecx = entry count (leaf; clobbers rax and rcx)
pick:
    cmp rdi, rcx
    jae .none
    mov rax, [rax + rdi * 8]
    ret
.none:
    xor eax, eax
    ret

; quiz_dimension(rdi = question index) -> rax: 0 extraversion, 1 neuroticism
quiz_dimension:
    mov rax, rdi
    and eax, 1
    ret

; quiz_temperament(rdi = extraversion yes count, rsi = neuroticism yes count) -> rax:
; 0 sanguine (E high, N low), 1 choleric (E high, N high), 2 phlegmatic (E low, N low), 3 melancholic
quiz_temperament:
    xor eax, eax
    cmp rdi, HIGH_AT
    jae .e_high
    add eax, 2
.e_high:
    cmp rsi, HIGH_AT
    jb .done
    inc eax
.done:
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
