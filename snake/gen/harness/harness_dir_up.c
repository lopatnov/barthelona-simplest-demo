// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=9c37a9945694c94a88b9a7dd82f6cc6f88e5def371eb3630732914c5ff652d4b
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(119ULL);
    long long want = 0LL;
    if (got != want) {
        printf("harness_dir_up: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
