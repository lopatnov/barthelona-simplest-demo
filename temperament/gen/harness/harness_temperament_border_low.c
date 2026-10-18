// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=8a87eddc20a2e816ff5471259d1db0d78d888545e481b06fc953ecb97ce321f6
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(3ULL, 3ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_temperament_border_low: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
