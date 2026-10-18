// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=a73f5cffc145d88b4bc5d345e2dc756c0ae5b745154bfdbbbf3a5533c0e80f06
#pragma once
#include <stddef.h>
#include <stdint.h>
enum { HIGH_AT = 4 };
enum { LINE_CAP = 16 };
enum { QUESTIONS = 12 };
// _start: no prototype (_start uses a custom ABI, which C cannot call)
uint64_t input_classify(uint64_t a0, uint64_t a1);
int64_t input_read_line(uint8_t * a0, uint64_t a1);
uint64_t quiz_dimension(uint64_t a0);
uint8_t * quiz_meaning(uint64_t a0);
uint8_t * quiz_name(uint64_t a0);
uint8_t * quiz_question(uint64_t a0);
uint64_t quiz_temperament(uint64_t a0, uint64_t a1);
void render_number(uint64_t a0);
void render_text(uint8_t * a0);
