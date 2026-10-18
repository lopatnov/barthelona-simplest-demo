// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=5a1a7475012412d75d820b476d551c5db7c405be5fe59a63ee61c4b64ff9bd06
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(1ULL, 48ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_classify_no_digit: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
