// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=9c62d64b0e8bd14662c71edbcb2ae891e26ca8303d159e299e0a6ab3def0c552
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(0ULL, 121ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_classify_empty_line: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
