// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=46cd1f4f2138fc2bc3c37040d97429020241170216a2c3c84cbe2f53af3e8cab
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(100ULL);
    long long want = 1LL;
    if (got != want) {
        printf("harness_dir_right: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
