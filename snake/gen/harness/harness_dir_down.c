// GENERATED from contracts.yaml, do not edit. barthelona-gen v1 body-sha256=865b963d209864e8cb21c5c94fb19582e7d3bd0f4c76d3353a34e97db0173639
#include <stdio.h>
#include "../contracts.h"
int main(void) {
    long long got = (long long)input_dir_of(115ULL);
    long long want = 2LL;
    if (got != want) {
        printf("harness_dir_down: got %lld, want %lld\n", got, want);
        return 1;
    }
    return 0;
}
