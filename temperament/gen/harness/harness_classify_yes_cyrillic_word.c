// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=23f1c2ff13ede7b3129b173cf51b58d729aa452e6a6aa48903d8294a43d899cd
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)input_classify(4ULL, 2966467792ULL);
    unsigned long long want = 1ULL;
    if (got != want) {
        printf("harness_classify_yes_cyrillic_word: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
