// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=671b64e00ae903c6af6eb73d253485858e097e22ca3727b7e43b8d00130c8c6a
#pragma once
#include <stddef.h>
#include <stdint.h>
enum { BOARD_H = 8 };
enum { BOARD_W = 16 };
enum { MAX_MOVES = 4096 };
// _start: no prototype (_start uses a custom ABI, which C cannot call)
uint64_t game_alive(void);
uint64_t game_cell(uint64_t a0, uint64_t a1);
void game_init(void);
uint64_t game_score(void);
uint64_t game_step(uint64_t a0);
int64_t input_dir_of(uint8_t a0);
uint64_t input_read_moves(uint8_t * a0, uint64_t a1);
void render_board(void);
void render_status(void);
