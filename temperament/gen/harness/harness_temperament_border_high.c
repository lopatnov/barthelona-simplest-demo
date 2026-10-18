// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=5e1af4c1be655d2976e142fe235e8f394735e91cd166050ce642999c79616106
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(4ULL, 4ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_temperament_border_high: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
