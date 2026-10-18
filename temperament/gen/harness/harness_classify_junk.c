// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=160c96be8565ccf2b0fa77490ac81bb6b1916c36e8e94a85a54934fe681e3bed
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(1ULL, 120ULL);
    unsigned long long want = 0ULL;
    if (got != want) {
        printf("harness_classify_junk: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
