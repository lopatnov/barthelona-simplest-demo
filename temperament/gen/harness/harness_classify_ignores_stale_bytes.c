// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=4fe95303ffebc761e9af07b9d8cbcd181efa3e0d9111ee1ee5e17e30d982e212
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(1ULL, 7562617ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_classify_ignores_stale_bytes: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
