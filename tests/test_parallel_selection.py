#!/usr/bin/env python3
"""Exercise public parallel CLI family selection, including partial-name typos."""
import csv
import io
import subprocess
import sys

FAMILIES = ("FastPattern", "FourSector", "Split64", "ByteSplit")


def names(families):
    return {
        family + mode
        for family in families
        for mode in (
            ("Serial", "Partitioned", "Atomic")
            if family == "FastPattern"
            else ("Serial", "Partitioned")
        )
    }


for executable in sys.argv[1:]:
    prefix = [executable, "5", "8", "12", "3", "1", "42", "50"]
    for selection in (
        "",
        "Unknown",
        "FastPattern,Unknown",
        "ByteSplit,ByteSplit",
        "ByteSplit,",
        ",ByteSplit",
        "FastPattern,,ByteSplit",
    ):
        result = subprocess.run(prefix + [selection], capture_output=True, text=True)
        assert result.returncode != 0 and not result.stdout, (
            executable,
            selection,
            result,
        )
    for selection, families in (
        (None, ["FastPattern"]),
        ("all", FAMILIES),
        ("ByteSplit", ["ByteSplit"]),
        ("Split64,ByteSplit", ["Split64", "ByteSplit"]),
    ):
        result = subprocess.run(
            prefix + ([] if selection is None else [selection]),
            capture_output=True,
            text=True,
            check=True,
        )
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        assert len(rows) == len(names(families))
        assert {row["filter"] for row in rows} == names(families)
        for family in families:
            group = [r for r in rows if r["filter"].startswith(family)]
            for field in ("filter_bytes", "false_positives", "result_checksum"):
                assert len({r[field] for r in group}) == 1, (family, field)
print(f"Parallel CLI selection contracts passed for {len(sys.argv) - 1} executables")
