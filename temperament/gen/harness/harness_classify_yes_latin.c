// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=5c076b675172c55d7e67b2d3e9fd3fde57ee4198da7bc1f2d16dc43e3c07b6b1
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(1ULL, 121ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_classify_yes_latin: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
