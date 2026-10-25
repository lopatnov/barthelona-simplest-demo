# temperament-questionnaire-nasm

An interactive temperament questionnaire written in NASM x86-64 assembly for Linux. It asks 12 alternating yes/no questions measuring extraversion and neuroticism, reads answers from stdin, scores each dimension 0-6, classifies the temperament as Sanguine, Choleric, Phlegmatic, or Melancholic, prints both scores and the temperament name, and exits with code 0. Uses only syscalls (write, read, exit) with no libc.

Linux x86-64, written in NASM, no libc. This repository was produced by
[Barthelona](https://github.com/lopatnov/barthelona): a person wrote only the request below; the
specification, the tests, the source and these files were generated, and NASM and the emulator accepted the
source.

## Requirements

- **R1**: Program prints question 1 as "Q1/12: Do you enjoy meeting new people? (y/n): " with no trailing newline
- **R2**: Program reads one line from stdin for each of the 12 questions in order
- **R3**: An answer counts as yes only if its first character is 'y' or 'Y'; any other first character (including EOF) counts as no
- **R4**: Extraversion score increments for yes answers to questions 1,3,5,7,9,11 and ranges 0-6
- **R5**: Neuroticism score increments for yes answers to questions 2,4,6,8,10,12 and ranges 0-6
- **R6**: After the 12th answer, program prints a newline followed by exactly three lines ending with newlines
- **R7**: First result line is exactly "Extraversion: <digit>" where digit is 0-6
- **R8**: Second result line is exactly "Neuroticism: <digit>" where digit is 0-6
- **R9**: Third result line is exactly "Temperament: <name>" where name is Sanguine, Choleric, Phlegmatic, or Melancholic
- **R10**: Temperament classification: Sanguine (E>=4, N<4), Choleric (E>=4, N>=4), Phlegmatic (E<4, N<4), Melancholic (E<4, N>=4)
- **R11**: Program exits with exit code 0
- **R12**: Program uses only sys_write, sys_read, and sys_exit syscalls; no libc functions

## Build and run

```
nasm -f elf64 -o build/temperament.o src/temperament.asm
ld -z noexecstack -e _start -o build/temperament-questionnaire-nasm-linux-x86_64 build/temperament.o
./build/temperament-questionnaire-nasm-linux-x86_64
```

Linux x86-64 only; on Windows use WSL2. Tagged releases (`v*`) carry the binary and its SHA-256.

## Test

The golden tests in `tests/golden.json` run the program in Barthelona's Unicorn emulator, never on the host.
A test passes when the exit code matches and stdout either matches exactly or, where a test lists texts,
contains each of them:

- **T1**: stdin `'y\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 6\n'`, `'Neuroticism: 6\n'`, `'Temperament: Choleric\n'` and exit code 0
- **T2**: stdin `'n\nn\nn\nn\nn\nn\nn\nn\nn\nn\nn\nn\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 0\n'`, `'Neuroticism: 0\n'`, `'Temperament: Phlegmatic\n'` and exit code 0
- **T3**: stdin `'y\nn\ny\nn\ny\nn\ny\nn\ny\nn\ny\nn\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 6\n'`, `'Neuroticism: 0\n'`, `'Temperament: Sanguine\n'` and exit code 0
- **T4**: stdin `'n\ny\nn\ny\nn\ny\nn\ny\nn\ny\nn\ny\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 0\n'`, `'Neuroticism: 6\n'`, `'Temperament: Melancholic\n'` and exit code 0
- **T5**: stdin `'y\ny\ny\ny\nn\nn\nn\nn\nn\nn\nn\nn\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 2\n'`, `'Neuroticism: 2\n'`, `'Temperament: Phlegmatic\n'` and exit code 0
- **T6**: stdin `'Y\nY\nY\nY\nY\nY\nY\nY\nY\nY\nY\nY\n'` gives stdout containing `'Q1/12: Do you enjoy meeting new people? (y/n): '`, `'Extraversion: 6\n'`, `'Neuroticism: 6\n'`, `'Temperament: Choleric\n'` and exit code 0

```
python -m barthelona check src/temperament.asm --tests tests/golden.json
```

The CI workflow installs a pinned Barthelona commit and runs that command. The result is not ABI-checked or
fuzzed: only the assembler and the emulated golden tests decided.

## How it was made

Request (also in `prompt/request.txt`):

> Write an interactive temperament questionnaire for the Linux x86-64 terminal as one NASM source file (elf64, syscalls only, no libc, no printf). Everything it prints is in English.
>
> It asks these 12 yes/no questions one at a time, in this order. Each question is printed as "Q<number>/12: <text> (y/n): " (the number is 1 to 12, there is no newline after the colon and space), and then the program reads one answer line from standard input. The questions alternate between extraversion (E) and neuroticism (N):
>
> 1 (E) Do you enjoy meeting new people?
> 2 (N) Do you often feel anxious?
> 3 (E) Do you like being the center of attention?
> 4 (N) Do you worry a lot about things that might go wrong?
> 5 (E) Do you prefer parties to quiet evenings?
> 6 (N) Does your mood change quickly?
> 7 (E) Do you talk easily to strangers?
> 8 (N) Do you often feel tense?
> 9 (E) Do you make friends easily?
> 10 (N) Do you get upset easily?
> 11 (E) Do you like to have people around you?
> 12 (N) Do you often feel guilty?
>
> An answer counts as yes when its first character is y or Y; anything else, including the end of the input, counts as no. Every yes adds one point to the dimension of its question, so each dimension scores from 0 to 6. A dimension is high when its score is at least 4, otherwise it is low.
>
> After the 12th answer the program prints a newline and then exactly these three lines (each ending with a newline), with the scores as single digits:
> Extraversion: <score>
> Neuroticism: <score>
> Temperament: <name>
>
> The name is Sanguine (extraversion high, neuroticism low), Choleric (high, high), Phlegmatic (low, low) or Melancholic (extraversion low, neuroticism high). The program then exits with code 0.
>
> The two score lines contain nothing after the score digit: they are exactly "Extraversion: 6" and "Neuroticism: 2", not "Extraversion: 6 (high)".
>
> The tests are exactly these six, one answer per line on standard input, and they check that the output contains the three result lines (and the first question) rather than comparing the whole output:
> 1. y to all 12 questions: Extraversion: 6, Neuroticism: 6, Temperament: Choleric.
> 2. n to all 12 questions: Extraversion: 0, Neuroticism: 0, Temperament: Phlegmatic.
> 3. y to the six E questions (1, 3, 5, 7, 9, 11) and n to the six N questions: Extraversion: 6, Neuroticism: 0, Temperament: Sanguine.
> 4. n to the E questions and y to the N questions: Extraversion: 0, Neuroticism: 6, Temperament: Melancholic.
> 5. y to questions 1 to 4 and n to the other eight: Extraversion: 2, Neuroticism: 2, Temperament: Phlegmatic.
> 6. Y (capital) to all 12 questions: Extraversion: 6, Neuroticism: 6, Temperament: Choleric.
> Every test expects exit code 0.
>
> Return one complete source file in a single code block.

- Run `run-20261025-015357-d7cd`, profile `meterless`, preset `linux-x64-nasm-static`, policy `v1`.
- Gates G1 (specification and tests) and G4 (source) were approved by a person.
- Repeat it: `python -m barthelona runs submit @prompt/request.txt --profile meterless --preset linux-x64-nasm-static`.

| Model | Calls | Tokens in | Tokens out | Seconds |
| --- | ---: | ---: | ---: | ---: |
| `meterless/auto` | 4 | 54128 | 12977 | 213.5 |
| `meterless/deep` | 9 | 169582 | 58958 | 916.7 |
