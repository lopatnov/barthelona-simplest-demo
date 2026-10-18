// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=2062e347f58324f219af1d0ed9bbe63d439227cdabfc47c40ce0a3513661e9b9
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(6ULL, 6ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_temperament_choleric: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
