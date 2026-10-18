// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=4b178556774165b4287fd037890ef5c1dcd18bfefdf9858606acd4b06f3b41db
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(6ULL, 0ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_temperament_sanguine: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
