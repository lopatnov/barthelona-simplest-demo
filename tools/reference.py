"""Python reference model of the temperament questionnaire.

The assembly in temperament/ must print exactly what this model prints for the same stdin bytes. The
golden cases in temperament/tests.yaml are produced from it by tools/make_tests.py, so a change in the
questions or the rules shows up as a diff in the committed golden file.

Method: Eysenck's two dimensions, extraversion (E) and neuroticism (N), combined into the four classical
temperaments. The twelve questions are original wording, not the copyrighted EPI items.
"""

from __future__ import annotations

import sys

LINE_CAP = 16
HIGH_AT = 4  # a dimension counts as "high" from this many "yes" answers (of 6)

QUESTIONS = (
    "Вы легко знакомитесь с новыми людьми?",
    "Ваше настроение часто меняется без видимой причины?",
    "Вам нравятся шумные вечеринки и большие компании?",
    "Вы долго переживаете после неприятного разговора?",
    "Вы обычно первым начинаете разговор?",
    "Вы часто волнуетесь по пустякам?",
    "Вам трудно усидеть на месте, когда вокруг ничего не происходит?",
    "Вам трудно успокоиться, когда что-то пошло не так?",
    "Вы быстро заводите друзей и охотно делитесь планами?",
    "Вы нередко чувствуете себя виноватым без серьёзных причин?",
    "Вы любите быть в центре внимания?",
    "Вы остро реагируете на критику?",
)

NAMES = ("САНГВИНИК", "ХОЛЕРИК", "ФЛЕГМАТИК", "МЕЛАНХОЛИК")

MEANINGS = (
    "Общительный, живой и уравновешенный. Быстро находит общий язык, легко переносит неудачи и "
    "переключается на новое. Слабая сторона - непостоянство и нехватка усидчивости.",
    "Общительный, энергичный и эмоционально возбудимый. Горит идеями и действует напористо, но бывает "
    "вспыльчив и нетерпелив. Помогает привычка делать паузу, прежде чем ответить.",
    "Спокойный, уравновешенный и сдержанный. Работает ровно и надёжно, не теряет головы в трудную минуту. "
    "Слабая сторона - медлительность и неохота к переменам.",
    "Чувствительный, вдумчивый и склонный к тревоге. Глубоко переживает и тонко замечает детали, но быстро "
    "устаёт и сомневается в себе. Помогают поддержка близких и чёткий распорядок.",
)

INTRO = (
    "=== Опросник темперамента ===\n"
    "Это короткий тест из 12 вопросов. Он оценивает два свойства по методике Айзенка:\n"
    "общительность (экстраверсию) и эмоциональную неустойчивость (нейротизм).\n"
    "Результат - ориентир, а не диагноз.\n"
    "\n"
    "Как отвечать: на каждый вопрос введите д (да) или н (нет) и нажмите Enter.\n"
    "Подойдут также y/n, да/нет и 1/0. Думайте недолго: первый ответ обычно самый честный.\n"
    "Чтобы выйти раньше, нажмите Ctrl+D.\n"
    "\n"
)
PROMPT = "Ваш ответ (д/н): "
RETRY = "Не понял ответ. Введите д или н (можно также y/n или 1/0).\n"
ABORT = "\nВвод закончился раньше времени, опросник прерван.\n"
OUTRO = "\nЭто ориентир, а не диагноз. Чтобы пройти тест ещё раз, запустите программу снова.\n"

YES_WORDS = ("д", "Д", "да", "Да", "ДА", "y", "Y", "yes", "Yes", "YES", "1")
NO_WORDS = ("н", "Н", "нет", "Нет", "НЕТ", "n", "N", "no", "No", "NO", "0")


def packed(word: str) -> int:
    return int.from_bytes(word.encode(), "little")


YES_VALUES = {packed(word) for word in YES_WORDS}
NO_VALUES = {packed(word) for word in NO_WORDS}


def classify(length: int, first_eight: int) -> int:
    """0 not an answer, 1 yes, 2 no. Mirrors input_classify: only the first *length* bytes count."""
    if length >= 8:
        return 0
    value = first_eight & ((1 << (8 * length)) - 1)
    return 1 if value in YES_VALUES else 2 if value in NO_VALUES else 0


def temperament(extraversion: int, neuroticism: int) -> int:
    """0 sanguine, 1 choleric, 2 phlegmatic, 3 melancholic."""
    return (0 if extraversion >= HIGH_AT else 2) + (1 if neuroticism >= HIGH_AT else 0)


def read_lines(data: bytes):
    """Lines as input_read_line sees them: CR, space and tab dropped, cut at LINE_CAP, EOF at the end."""
    line = bytearray()
    for byte in data:
        if byte == 10:
            yield bytes(line)
            line.clear()
        elif byte not in (9, 13, 32) and len(line) < LINE_CAP:
            line.append(byte)
    if line:
        yield bytes(line)


def run(data: bytes) -> tuple[str, int]:
    """The program's stdout and exit code for the given stdin bytes."""
    lines = read_lines(data)
    out = [INTRO]
    scores = [0, 0]  # extraversion, neuroticism
    for index, question in enumerate(QUESTIONS):
        out.append(f"Вопрос {index + 1} из {len(QUESTIONS)}\n{question}\n")
        while True:
            out.append(PROMPT)
            line = next(lines, None)
            if line is None:
                out.append(ABORT)
                return "".join(out), 1
            answer = classify(len(line), int.from_bytes(line[:8], "little"))
            if answer:
                break
            out.append(RETRY)
        if answer == 1:
            scores[index % 2] += 1
    kind = temperament(*scores)
    out.append(
        f"\nРезультат\nОбщительность (экстраверсия): {scores[0]} из 6\n"
        f"Эмоциональная неустойчивость (нейротизм): {scores[1]} из 6\n\n"
        f"Ваш темперамент: {NAMES[kind]}\n{MEANINGS[kind]}\n"
    )
    out.append(OUTRO)
    return "".join(out), 0


if __name__ == "__main__":
    text, code = run(sys.stdin.buffer.read())
    sys.stdout.write(text)
    sys.exit(code)
