// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=649f0781105ef9265325da25bb4e9161dbf5859d13faa081766aab959701ebae
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(2ULL, 40400ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_classify_no_cyrillic_upper: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
