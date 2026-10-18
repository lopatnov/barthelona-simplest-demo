// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=9f2a09f07624ad16f70ccb34722414d2661162380955f5e549e6b4c79b557396
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(2ULL, 28526ULL);
    unsigned long long want = 2ULL;
    if (got != want) {
        printf("harness_classify_no_latin_word: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
