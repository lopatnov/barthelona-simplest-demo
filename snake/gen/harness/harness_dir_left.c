// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=de3cd51576b5e025d540c8b14f686d4fec1ce6e3814d1d49381ae5ec89c3b812
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(97ULL);
    long long want = 3LL;
    if (got != want) {
        printf("harness_dir_left: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
