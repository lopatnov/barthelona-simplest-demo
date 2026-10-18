// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=1161864376908e6aa6ee500cc1c814b8b6f7ccb666f1bb6338fc9a2b8bd84dc7
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(9ULL, 7562617ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_classify_too_long: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
