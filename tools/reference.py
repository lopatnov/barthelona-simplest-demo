"""Python reference model of the Snake rules.

The assembly in snake/ must print exactly what this model prints for the same keys. The golden
cases in snake/tests.yaml are produced from it by tools/make_tests.py, so a change in the rules
shows up as a diff in the committed golden file.
"""

from __future__ import annotations

import sys
from dataclasses import dataclass, field

WIDTH = 16
HEIGHT = 8
SEED = 12345
TRIES = 4096
KEYS = {"w": 0, "d": 1, "s": 2, "a": 3}
STEPS = ((0, -1), (1, 0), (0, 1), (-1, 0))  # up, right, down, left


@dataclass
class Game:
    body: list[tuple[int, int]] = field(default_factory=lambda: [(8, 4), (7, 4), (6, 4)])  # head first
    heading: int = 1
    score: int = 0
    dead: bool = False
    rng: int = SEED
    food: tuple[int, int] = (0, 0)

    def __post_init__(self) -> None:
        self.food = self._next_food()

    def _next_food(self) -> tuple[int, int]:
        for _ in range(TRIES - 1):
            self.rng = (self.rng * 1103515245 + 12345) & 0x7FFFFFFF
            cell = ((self.rng >> 16) % WIDTH, (self.rng >> 8) % HEIGHT)
            if cell not in self.body:
                return cell
        return (255, 255)

    def step(self, direction: int) -> int:
        """0 moved, 1 ate, 2 died, 3 ignored (already dead)."""
        if self.dead:
            return 3
        if direction == (self.heading + 2) % 4:
            direction = self.heading
        self.heading = direction
        dx, dy = STEPS[direction]
        new = (self.body[0][0] + dx, self.body[0][1] + dy)
        if not (0 <= new[0] < WIDTH and 0 <= new[1] < HEIGHT):
            self.dead = True
            return 2
        ate = new == self.food
        solid = self.body if ate else self.body[:-1]
        if new in solid:
            self.dead = True
            return 2
        self.body.insert(0, new)
        if not ate:
            self.body.pop()
            return 0
        self.score += 1
        self.food = self._next_food()
        return 1

    def cell(self, x: int, y: int) -> str:
        if (x, y) == self.body[0]:
            return "X" if self.dead else "O"
        if (x, y) in self.body:
            return "o"
        return "*" if (x, y) == self.food else " "

    def render(self) -> str:
        border = "+" + "-" * WIDTH + "+\n"
        rows = ("|" + "".join(self.cell(x, y) for x in range(WIDTH)) + "|\n" for y in range(HEIGHT))
        status = "ALIVE" if not self.dead else "GAME OVER"
        return border + "".join(rows) + border + f"SCORE {self.score}\n{status}\n"


def play(keys: str) -> Game:
    game = Game()
    for key in keys:
        if key.lower() in KEYS:
            game.step(KEYS[key.lower()])
    return game


if __name__ == "__main__":
    sys.stdout.write(play(sys.stdin.read()).render())
