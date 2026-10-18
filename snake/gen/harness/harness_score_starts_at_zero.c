// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=00a008f3739f610ba64c65cd6b400d59930c208119ebb5a61a80122d9432c4bd
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)game_score();
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_score_starts_at_zero: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
