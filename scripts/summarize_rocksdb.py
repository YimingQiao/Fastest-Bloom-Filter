#!/usr/bin/env python3
"""Summarize the fixed, one-seed RocksDB-inclusive screening matrix."""
import csv
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
DIRECTORY = ROOT / "results/2026-10-29-rocksdb-screen"
OURS = {"FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter"}
TIERS = ((16, "0.01"), (16, "0.001"), (32, "0.0001"))


def read(path):
    with path.open() as handle:
        return list(csv.DictReader(handle))


def main():
    raw = read(DIRECTORY / "results.csv")
    assert len(raw) == 240, "the 20-configuration × 12-case matrix must be complete"
    assert {r["seed"] for r in raw} == {"42"}
    assert len({r["filter"] for r in raw}) == 20
    for keys in (1 << 16, 1 << 25):
        for bpk in (8, 16):
            for batch in (1, 31, 4096):
                case = [
                    r
                    for r in raw
                    if int(r["keys"]) == keys
                    and int(r["requested_bpk"]) == bpk
                    and int(r["batch"]) == batch
                ]
                assert len(case) == 20 and len({r["filter"] for r in case}) == 20
                assert all(
                    int(r["calibration_absent_queries"]) == 1 << 24
                    and int(r["queries"]) == 1 << 22
                    and r["repeats"] == "3"
                    and r["hit_percent"] == "50"
                    and int(r["insert_batch"]) == keys
                    for r in case
                )
    rankings = {}
    for metric in ("hash_lookup_ns", "lookup_ns", "hash_insert_ns"):
        for cap in (16, 32):
            path = DIRECTORY / f"{metric}-ranking-{cap}.csv"
            subprocess.run(
                [
                    sys.executable,
                    str(ROOT / "scripts/rank_external.py"),
                    str(DIRECTORY / "results.csv"),
                    "--max-bpk",
                    str(cap),
                    "--allocation-slack",
                    "0",
                    "--metric",
                    metric,
                    "--output",
                    str(path),
                ],
                check=True,
            )
            rankings[metric, cap] = read(path)

    def eligible(metric, cap, target, keys, batch):
        return [
            r
            for r in rankings[metric, cap]
            if r["fpr_target"] == target
            and int(r["keys"]) == keys
            and int(r["batch"]) == batch
        ]

    def best(rows, predicate):
        return min(
            (r for r in rows if predicate(r)), key=lambda r: float(r["ns_per_key"])
        )

    query = []
    construction = []
    for keys in (1 << 16, 1 << 25):
        for batch in (1, 31, 4096):
            for cap, target in TIERS:
                rows = eligible("hash_lookup_ns", cap, target, keys, batch)
                native = best(rows, lambda r: r["filter"] in OURS)
                external = best(rows, lambda r: r["filter"] not in OURS)
                rocks = best(rows, lambda r: r["filter"].startswith("RocksDB"))
                ratio = float(external["ns_per_key"]) / float(native["ns_per_key"])
                query.append(
                    f"| {keys:,} | {batch} | {cap} / {float(target):.2%} | "
                    f"{native['filter']} | {float(native['ns_per_key']):.3f} | "
                    f"{external['filter']} | {float(external['ns_per_key']):.3f} | "
                    f"{ratio:.2f}× | {rocks['filter']}: {float(rocks['ns_per_key']):.3f} |"
                )
                if batch == 4096:
                    builds = eligible("hash_insert_ns", cap, target, keys, batch)
                    own = best(builds, lambda r: r["filter"] in OURS)
                    other = best(builds, lambda r: r["filter"] not in OURS)
                    construction.append(
                        f"| {keys:,} | {cap} / {float(target):.2%} | "
                        f"{own['filter']} | {float(own['ns_per_key']):.3f} | "
                        f"{other['filter']} | {float(other['ns_per_key']):.3f} |"
                    )
    report = (
        """# RocksDB-inclusive screening — 2026-10-29

This exploratory comparison adds all eight pinned RocksDB FastLocalBloom core
configurations to a 20-configuration shortlist: three current native layouts,
five FastFilter variants, three Boost.Bloom variants and PageBloom6Compact.
The complete matrix has **240 rows: 20 configurations × 12 cases**. It measures
generic batch calls with counts 1, 31 and 4096; count 1 is throughput through the
batch API, not serialized latency or a fused public raw-key single-query API.

One Xeon Platinum 8474C core (CPU 2), Clang 23, common native ISA, 65K/32M keys,
requested 8/16 bits per key, 50% hits, seed 42, 2^22 timed queries and three
repetitions. Each construction call receives the full insertion set. Independent
2^24-negative calibration follows timing. Bitmap payloads span 128 KiB–128 MiB;
queries are warmed and repeated, so a large bitmap does not imply cold accesses.

Ranking uses a payload-allocation ceiling with zero slack and a one-sided,
pointwise 95% Wilson FPR bound. Every candidate may choose either tested allocation
under the ceiling. This one-seed screen does not establish a held-out performance
win. Separate prehashed and construction rankings are retained with the raw data.
Native kernels and the new selection/output guards are frozen at `6c2eaa9`;
later ByteSplit integration is absent from this executable.

## Hash plus query

Times are median ns/key. Speedup is external/native, so values below one are
native losses. The RocksDB column shows its fastest eligible configuration in
the same cell; it measures unchanged core primitives, excluding SST/database work.

| Keys | Batch | Bits/key ceiling / FPR ceiling | Native query leader | ns/key | External query leader | ns/key | Speedup | Best RocksDB core, ns/key |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
"""
        + "\n".join(query)
        + """

## Hash plus construction

These rows use the batch-4096 cases solely to select one recorded construction
measurement per configuration. Insertion batching is independently fixed to the
full input. Times include hashing and insertion, excluding bitmap allocation and
zeroing; allocate+hash+insert remains in the raw CSV. Query speed does not imply
construction speed.

| Keys | Bits/key ceiling / FPR ceiling | Native construction leader | ns/key | External construction leader | ns/key |
| --- | --- | --- | --- | --- | --- |
"""
        + "\n".join(construction)
        + """

The full combined executable had 53 configurations; this stage uses the listed
shortlist, not the whole search space. The separately measured FastFilter single
shortcut controls and optional PageBloom AES mode are not in this screen. Neither
this shortlist nor the native-only scaling study establishes a multithreaded win
over every external library. New native ByteSplit measurements are separate.

The first attempted matrix was interrupted after a misspelled filter name silently
omitted FastPattern. Its seven completed cases are retained as rejected evidence
and are excluded here. Both language harnesses now reject partial selections,
and the runner verifies exact names/workload fields. Full first-timed prehashed
and hash+query output checksums are checked outside the timers; corruption tests
exercise those guards.

[Complete raw matrix, rankings and provenance](../results/2026-10-29-rocksdb-screen/),
[RocksDB adapter contract](../benchmarks/rocksdb-external/README.md),
[rejected preliminary run](../results/2026-10-29-rocksdb-screen-rejected/REJECTED.md).
Regenerate with `python3 scripts/summarize_rocksdb.py`.
"""
    )
    (ROOT / "docs/rocksdb-screen-2026-10-29.md").write_text(report)
    print("Wrote 240-row RocksDB-inclusive screening report and six rankings")


if __name__ == "__main__":
    main()
