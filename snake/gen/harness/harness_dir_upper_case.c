// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=2def0c61a465a98869dd2a5b36cba1408d1c6b5cf9139b8cdcf75dadce18531e
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(83ULL);
    long long want = 2LL;
    if (got != want) {
        printf("harness_dir_upper_case: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
