#!/usr/bin/env python3
"""Opt-in CLI defaults, early rejection, exact family grouping and cross-language parity."""
import argparse
import csv
import io
from pathlib import Path
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from parallel_selection import DEFAULT_FAMILIES, family_rows, mode_names, selected_families

OPTIONAL = ("Split64Range", "FourSectorRange12")
CLASSES = tuple(family + "BloomFilter" for family in OPTIONAL)
FIELDS = ("keys", "queries", "requested_bpk", "filter_bytes", "absent_queries",
          "false_positives", "result_checksum")


def invoke(exe, args, accepted=True):
    result = subprocess.run([exe, *map(str, args)], capture_output=True, text=True)
    if not accepted:
        assert result.returncode != 0 and result.stdout == "", (exe, args, result)
        return []
    assert result.returncode == 0, (exe, args, result.stderr)
    rows = list(csv.DictReader(io.StringIO(result.stdout)))
    assert rows and len({r["filter"] for r in rows}) == len(rows), (exe, args, rows)
    return rows


def exact(rows, expected):
    assert {r["filter"] for r in rows} == set(expected), rows


def semantics(rows):
    return {r["filter"]: tuple(r[field] for field in FIELDS) for r in rows}


def runner_contract():
    assert selected_families("all") == list(DEFAULT_FAMILIES)
    assert selected_families(",".join(OPTIONAL)) == list(OPTIONAL)
    for invalid in ("", "all,Split64Range", "Split64Range,", "Split64Range,Split64Range",
                    "Split64,Unknown", " FourSectorRange12"):
        try:
            selected_families(invalid)
        except ValueError:
            pass
        else:
            raise AssertionError(invalid)
    # Distinct values expose the old startswith grouping bug.
    families = ("Split64", "Split64Range", "FourSector", "FourSectorRange12")
    rows = [dict(filter=name, identity=family) for family in families for name in mode_names(family)]
    for family in families:
        assert {r["identity"] for r in family_rows(rows, family)} == {family}


def compare(exe):
    prefix = [10, 8, 50, 12, 31, 1, 731]
    defaults = invoke(exe, prefix)
    assert not set(CLASSES) & {r["filter"] for r in defaults}
    assert semantics(invoke(exe, [*prefix, ""])) == semantics(defaults)
    for name in CLASSES:
        exact(invoke(exe, [*prefix, name]), [name])
    for selection in (f"{CLASSES[0]},Unknown", f"Unknown,{CLASSES[1]}",
                      f"{CLASSES[0]},{CLASSES[0]}", f"{CLASSES[0]},", f",{CLASSES[1]}"):
        invoke(exe, [*prefix, selection], accepted=False)
    for name in CLASSES:
        # n32/bpk8 gives32B: even a valid legacy prefix must not execute first.
        for selection in (name, f"FastPatternBF,{name}"):
            invoke(exe, [5, 8, 50, 12, 31, 1, 731, selection], accepted=False)
    names = ("Split64BloomFilter", *CLASSES, "FourSectorBloomFilter")
    rows = invoke(exe, [15, 20, 50, 15, 31, 1, 731, ",".join(names)])
    exact(rows, names)
    for row in rows:
        if row["filter"] in CLASSES:
            assert int(row["filter_bytes"]) == (1 << 15) * 20 // 8
    return semantics(rows)


def parallel(exe):
    prefix = [10, 8, 12, 3, 1, 731, 50]
    exact(invoke(exe, prefix), mode_names("FastPattern"))
    exact(invoke(exe, [*prefix, "all"]), set().union(*(mode_names(f) for f in DEFAULT_FAMILIES)))
    for family in OPTIONAL:
        exact(invoke(exe, [*prefix, family]), mode_names(family))
    for selection in ("", "Split64Range,Unknown", "FourSectorRange12,FourSectorRange12",
                      "Split64Range,", ",FourSectorRange12", "Split64,,Split64Range"):
        invoke(exe, [*prefix, selection], accepted=False)
    for family in OPTIONAL:
        for selection in (family, f"FastPattern,{family}"):
            invoke(exe, [5, 8, 12, 3, 1, 731, 50, selection], accepted=False)
    families = ("Split64", "Split64Range", "FourSector", "FourSectorRange12")
    rows = invoke(exe, [15, 20, 15, 3, 1, 731, 50, ",".join(families)])
    exact(rows, set().union(*(mode_names(f) for f in families)))
    for family in families:
        group = family_rows(rows, family)
        for field in FIELDS:
            assert len({r[field] for r in group}) == 1, (family, field, group)
        part = next(r for r in group if r["filter"] == family + "Partitioned")
        assert int(part["build_workers"]) == int(part["query_workers"]) == 3
        if family in OPTIONAL:
            assert int(part["filter_bytes"]) == (1 << 15) * 20 // 8
    return semantics(rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compare", action="append", default=[])
    parser.add_argument("--parallel", action="append", default=[])
    args = parser.parse_args()
    runner_contract()
    for executables, check in ((args.compare, compare), (args.parallel, parallel)):
        reference = None
        for executable in executables:
            observed = check(executable)
            if reference is not None:
                assert observed == reference, (executable, observed, reference)
            reference = observed
    print("Optional CLI defaults, exact grouping, early rejection and supplied-binary parity passed")


if __name__ == "__main__":
    main()
