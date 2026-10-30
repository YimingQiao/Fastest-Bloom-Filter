"""Independent small-fixture input oracle and fixed public accuracy scope."""

import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GEOMETRY = HERE.with_name("2026-10-29-poppy-public-geometry")
SEMANTICS = HERE.with_name("2026-10-29-poppy-public-semantics")
MASK = (1 << 64) - 1
STEP = 0x9E3779B97F4A7C15
Q = 1 << 22
CAL = 1 << 26


def need(ok, message):
    if not ok:
        raise ValueError(message)


def constructors():
    rows = json.loads((GEOMETRY / "selection.json").read_text())["rows"]
    need(
        len(rows) == 86 and len({r["id"] for r in rows}) == 86, "Wrong constructor grid"
    )
    return rows


def fixtures():
    rows = constructors()
    return [
        next(r for r in rows if r["n"] == n and r["policy"] == policy)
        for n in (65536, 33554432)
        for policy in ("none", "space", "speed", "best")
    ]


def splitmix(value):
    value = ((value ^ (value >> 30)) * 0xBF58476D1CE4E5B9) & MASK
    value = ((value ^ (value >> 27)) * 0x94D049BB133111EB) & MASK
    return value ^ (value >> 31)


def key_base(n):
    return splitmix((42 + STEP) & MASK) % ((1 << 32) - n - Q)


def small_input(n):
    # Independently implement the old producer's mutable RNG and both shuffles.
    state = 42

    def draw():
        nonlocal state
        state = (state + STEP) & MASK
        return splitmix(state)

    base = draw() % ((1 << 32) - n - Q)
    inserted = list(range(base, base + 1031))

    def shuffle(values):
        for count in range(len(values), 1, -1):
            other = draw() % count
            values[count - 1], values[other] = values[other], values[count - 1]

    shuffle(inserted)
    queries = [base + (draw() % 1031 if i % 100 < 50 else n + i) for i in range(8193)]
    shuffle(queries)

    def digest(values):
        total = 14695981039346656037
        for value in values:
            total = ((total ^ value) * 1099511628211) & MASK
        return total

    return dict(
        key_base=base,
        inserted_checksum=digest(inserted),
        query_checksum=digest(queries),
    )


def validate(row, expected, check):
    n = expected["n"]
    q, inserted, calibration = (8193, 1031, 4096) if check else (Q, n, CAL)
    for field, value in dict(
        stage="check" if check else "accuracy",
        id=expected["id"],
        real_n=n,
        inserted_n=inserted,
        queries=q,
        policy=expected["policy"],
        fpp_bits=expected["fpp_bits"],
        actual_bytes=expected["backing_bytes"],
        seed=42,
        key_base=key_base(n),
        false_negatives=0,
        present_queries=q // 100 * 50 + min(q % 100, 50),
        calibration_queries=calibration,
        check_public_iterator_parity=check,
        timings=False,
    ).items():
        need(row[field] == value, "Wrong fixed accuracy field: " + field)
    need(
        row["absent_queries"] + row["present_queries"] == q, "Mixed denominator changed"
    )
    need(
        0 <= row["mixed_false_positives"] <= row["absent_queries"],
        "Invalid mixed FP count",
    )
    need(
        0 <= row["calibration_false_positives"] <= calibration,
        "Invalid calibration FP count",
    )
    need(
        0 < row["insertions_returned_new"] <= inserted,
        "Invalid public insert return count",
    )
    need(
        row["calibration_begin"] == key_base(n) + n + Q, "Wrong independent range start"
    )
    need(
        row["calibration_end"] == row["calibration_begin"] + calibration,
        "Wrong independent range end",
    )
    if check:
        for field, value in small_input(n).items():
            need(
                row[field] == value, "Independent input/shuffle oracle failed: " + field
            )


def check_coverage(rows):
    expected = constructors()
    need(len(rows) == 86, "Incomplete fixed calibration grid")
    for row, constructor in zip(rows, expected, strict=True):
        validate(row, constructor, False)
    # Identical source mappings reuse the same input stream; do not pool their
    # denominators. The already proved None/Space pairs are explicitly checked.
    by_params = {(r["real_n"], r["policy"], r["fpp_bits"]): r for r in rows}
    for row in rows:
        if row["policy"] != "space":
            continue
        other = by_params[(row["real_n"], "none", row["fpp_bits"])]
        for field in (
            "actual_bytes",
            "inserted_checksum",
            "query_checksum",
            "insertions_returned_new",
            "mixed_false_positives",
            "result_checksum",
            "calibration_false_positives",
        ):
            need(row[field] == other[field], "Proven public None/Space alias changed")
