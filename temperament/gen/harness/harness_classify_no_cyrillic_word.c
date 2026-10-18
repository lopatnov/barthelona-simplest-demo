// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=d41d1888698dd3903db397ec93124684a018993f11c820dc344ae074f2430bbf
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(6ULL, 143837210131920ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_classify_no_cyrillic_word: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
