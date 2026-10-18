// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=e48a40e976b932b7c5a6fe42a3c00df1c755a00b7b697f0eb7b3a4898747ace2
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(3ULL, 7554425ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_classify_mixed_case_rejected: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
