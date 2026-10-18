// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=c84311d2ba6988581038cb63f0ed075ff45349ac75f6408491ee977f97cc6106
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(1ULL, 49ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_classify_yes_digit: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
