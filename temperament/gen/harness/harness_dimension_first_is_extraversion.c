// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=a1b00da96f9e3527fa8c253b8b8ee0babe86012722ae8204981fdedd16ce23f3
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_dimension(0ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_dimension_first_is_extraversion: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
