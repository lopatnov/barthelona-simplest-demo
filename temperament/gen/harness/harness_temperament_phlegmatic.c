// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=73aa892fd1c1bd4aa5ce345db8f76cc43c5bdfbbc990b5a5018c46e7d2ad8774
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(0ULL, 0ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_temperament_phlegmatic: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
