#!/usr/bin/env python3
"""Summarize paired-seed scaling for the two new native layouts."""
import csv
from pathlib import Path
from statistics import median

ROOT = Path(__file__).resolve().parents[1]


def main():
    table = []
    details = []
    for language in ("cpp", "rust"):
        directory = ROOT / f"results/2026-10-28-layout-parallel-{language}"
        with (directory / "results.csv").open() as f:
            rows = list(csv.DictReader(f))
        assert len(rows) == 96
        assert {r["seed"] for r in rows} == {"307", "509", "1021"}
        for keys in (1 << 24, 1 << 25):
            for family in ("FourSector", "Split64"):
                base = {
                    r["seed"]: r
                    for r in rows
                    if int(r["keys"]) == keys
                    and r["filter"] == family + "Serial"
                    and r["threads"] == "1"
                }
                assert len(base) == 3
                for threads in (1, 2, 4, 8):
                    rr = [
                        r
                        for r in rows
                        if int(r["keys"]) == keys
                        and r["filter"] == family + "Partitioned"
                        and int(r["threads"]) == threads
                    ]
                    assert len(rr) == 3
                    for r in rr:
                        for field in (
                            "result_checksum",
                            "filter_bytes",
                            "false_positives",
                            "absent_queries",
                        ):
                            assert r[field] == base[r["seed"]][field]
                    build = median(
                        float(base[r["seed"]]["insert_ns"]) / float(r["insert_ns"])
                        for r in rr
                    )
                    query = median(
                        float(base[r["seed"]]["lookup_ns"]) / float(r["lookup_ns"])
                        for r in rr
                    )
                    details.append(
                        {
                            "language": language,
                            "keys": keys,
                            "layout": family,
                            "threads": threads,
                            "build_speedup": build,
                            "query_speedup": query,
                            "build_ns": median(float(r["insert_ns"]) for r in rr),
                            "query_ns": median(float(r["lookup_ns"]) for r in rr),
                            "scratch_bytes": rr[0]["build_scratch_bytes"],
                        }
                    )
                    if threads == 8:
                        table.append(
                            f"| {('C++' if language == 'cpp' else 'Rust')} | {keys:,} | {family} | {build:.2f}× | {query:.2f}× | {details[-1]['build_ns']:.3f} | {details[-1]['query_ns']:.3f} |"
                        )
    out = ROOT / "results/layout-parallel-summary.csv"
    with out.open("w", newline="") as f:
        writer = csv.DictWriter(f, details[0].keys(), lineterminator="\n")
        writer.writeheader()
        writer.writerows(details)
    report = (
        """# Native layout scaling — 2026-10-28

Both new native layouts support exclusive parallel construction and parallel
immutable membership queries. This measures scaling against each layout's own
serial implementation, not a multithreaded victory over an external library.
Overlapping insertion/query remains a separate FastPattern atomic API.

Each language has 24 cases and 96 rows: 16M/32M keys, 1/2/4/8 physical cores,
three seeds, and serial/partitioned modes for FourSector and Split64. Native actual
allocation is 16 bits/key (32/64 MiB bitmaps), with 2^22 prehashed queries, 50% hits
and three repetitions. CPU affinity is the first T CPUs in 2,4,6,8,10,12,14,16 on
one Xeon Platinum 8474C socket. C++ and Rust matrices ran serially. These tests use
the frozen native implementations before the subsequent short-batch query change.

Speedups below are medians of paired-seed ratios to the one-core serial row.
Build timing includes partitioning, scratch allocation and thread startup; initial
bitmap allocation/zeroing and source hashing are outside this parallel timer.
Query timing includes thread startup and output stores, with hashing excluded.
All inserted keys are checked, and complete query checksums match serial and
partitioned modes in every case. Three-seed medians are not guarantees on other
machines, sizes or query distributions.

| Language | Keys | Layout | 8-core build speedup | 8-core query speedup | Build ns/key | Query ns/key |
| --- | --- | --- | --- | --- | --- | --- |
"""
        + "\n".join(table)
        + """

Partitioning needs eight bytes per input hash plus aligned counters and worker
metadata, about 128/256 MiB scratch at these input sizes. It does not allocate one
bitmap per worker. C++ and Rust report their own partitioning data scratch bytes;
Rust's safe scatter-slice descriptors add a small amount. Allocator metadata,
thread launch bookkeeping, and OS thread stacks are excluded. The CSV retains
exact values and trial minimum/maximum times.

This stage does not compare atomic and exclusive-build semantics as interchangeable.
It also does not establish a speedup for tiny filters, where startup can dominate.

[C++ raw data/provenance](../results/2026-10-28-layout-parallel-cpp/),
[Rust raw data/provenance](../results/2026-10-28-layout-parallel-rust/),
[all 1–8 core summaries](../results/layout-parallel-summary.csv).

Reproduce with `scripts/run_parallel.py --filters FourSector,Split64` and the
recorded metadata arguments. Use `scripts/summarize_layout_parallel.py` to regenerate
this report. The frozen binary source revisions are recorded separately from any
later workspace changes.
"""
    )
    (ROOT / "docs/layout-parallel-2026-10-28.md").write_text(report)
    print("Wrote native layout scaling report and summaries")


if __name__ == "__main__":
    main()
