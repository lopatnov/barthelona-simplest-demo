// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=f70cb6294daade20e48b4fd92766ed30acbf6a938cf0750c5ef5e31328bd35fe
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_dimension(1ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_dimension_second_is_neuroticism: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
