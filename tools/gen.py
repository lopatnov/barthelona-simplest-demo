"""Regenerate temperament/gen/ from temperament/contracts.yaml with barthelona's codegen (needs `pip install barthelona`)."""

from __future__ import annotations

from pathlib import Path

from barthelona.contracts import load_registry, load_test_cases
from barthelona.contracts.codegen import render_all

PROJECT = Path(__file__).parents[1] / "temperament"

registry = load_registry(PROJECT / "contracts.yaml")
tests = load_test_cases(PROJECT / "tests.yaml")
for name, text in render_all(registry, tests).items():
    target = PROJECT / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {target.relative_to(PROJECT.parent)}")
