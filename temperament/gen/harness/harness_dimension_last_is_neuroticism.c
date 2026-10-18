// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=695ecaa14e1870be7569d11e83d12b35e3454f8dd20f0a97246a31403ef3487e
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_dimension(11ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_dimension_last_is_neuroticism: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
