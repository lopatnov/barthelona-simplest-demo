// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=d961bba1caa722bf9521ce207682a88ba1ee6d50f67a45520a60d8a223f34197
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(120ULL);
    long long want = -1LL;
    if (got != want) {
        printf("harness_dir_other_key: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
