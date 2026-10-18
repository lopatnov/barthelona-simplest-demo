An interactive temperament questionnaire (Russian interface) in four NASM modules, checked by [barthelona](https://github.com/lopatnov/barthelona)'s verification ladder.

**Platform: Linux x86-64 only.** It is a static ELF64 binary that uses raw Linux syscalls and no libc. It does not run natively on Windows, macOS or ARM. On Windows, run it inside WSL2.

## Run

```
sha256sum -c temperament-linux-x86_64.sha256
chmod +x temperament-linux-x86_64
./temperament-linux-x86_64
```

The program explains itself: it asks 12 yes/no questions one by one (answer `д` or `н`, also `y/n`, `да/нет`, `1/0`), re-asks when it does not understand, and ends with your temperament: sanguine, choleric, phlegmatic or melancholic. Ctrl+D quits early. The result is a rough guide, not a diagnosis. Run a binary you downloaded in a sandbox you trust; the repository's CI runs it only inside barthelona's locked-down container.

## Who wrote what

The assembly was **written by Claude**, not by barthelona's agents, because barthelona's engine does not exist yet. barthelona's own parts (codegen, tamper gate, V0, V1, V2, V5, V6) verified it in CI. This binary was compiled by the `release` workflow on GitHub from the tagged commit. See the README for details.
