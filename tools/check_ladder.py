"""Read `barthelona verify` output on stdin and require the levels this project needs to pass.

`verify` exits 1 while V3 and V4 have no check (barthelona issue #123), so CI cannot use its exit
code. This script fails unless every required level reports `pass` and nothing else failed.
"""

from __future__ import annotations

import re
import sys

REQUIRED = ("tamper", "V0", "V1", "V2", "V5", "V6")
ALLOWED_UNSUPPORTED = ("V3", "V4")  # Phase 2 checks that do not exist yet
LINE = re.compile(r"^\s+\S+ (?P<level>\w+): (?P<status>\w+) \(")


def main() -> int:
    text = sys.stdin.read()
    sys.stdout.write(text)
    status = {m["level"]: m["status"] for line in text.splitlines() if (m := LINE.match(line))}
    problems = [f"{level}: {status.get(level, 'missing')}" for level in REQUIRED if status.get(level) != "pass"]
    problems += [
        f"{level}: {state}"
        for level, state in status.items()
        if state in ("fail", "skipped") or (state == "unsupported" and level not in ALLOWED_UNSUPPORTED)
    ]
    if problems:
        sys.stderr.write("ladder check failed: " + "; ".join(sorted(set(problems))) + "\n")
        return 1
    sys.stdout.write("ladder check passed: " + ", ".join(REQUIRED) + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
