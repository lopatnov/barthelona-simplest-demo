A Snake game in four NASM modules, checked by [barthelona](https://github.com/lopatnov/barthelona)'s verification ladder.

**Platform: Linux x86-64 only.** It is a static ELF64 binary that uses raw Linux syscalls and no libc. It does not run natively on Windows, macOS or ARM. On Windows, run it inside WSL2.

## Run

```
sha256sum -c snake-linux-x86_64.sha256
chmod +x snake-linux-x86_64
printf 'ddddsssaaaaaaaawwwd' | ./snake-linux-x86_64
```

It reads a script of keys (`w a s d`, either case) from stdin and prints the final 16x8 board and score. Run a binary you downloaded in a sandbox you trust; the repository's CI runs it only inside barthelona's locked-down container.

## Who wrote what

The assembly was **written by Claude**, not by barthelona's agents, because barthelona's engine does not exist yet. barthelona's own parts (codegen, tamper gate, V0, V1, V2, V5, V6) verified it in CI. This binary was compiled by the `release` workflow on GitHub from the tagged commit. See the README for details.
