// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=b5721cd547c56d228582613aac85fba0c896e062b239e36aa6cb94ed0de59325
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(2ULL, 46288ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_classify_yes_cyrillic: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
