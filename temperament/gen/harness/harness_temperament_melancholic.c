// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=4c28f36a3b583698ce81bd73391873bbcd53fbfa12b74a0dd1d23975d5ba7cdd
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    unsigned long long got = (unsigned long long)quiz_temperament(0ULL, 6ULL);
    unsigned long long want = 3ULL;
    if (got != want) {
        printf("harness_temperament_melancholic: got %llu, want %llu\n", got, want);
        return 1;
    }
    return 0;
}
