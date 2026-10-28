#!/usr/bin/env python3
"""Report native ByteSplit confirmation without inheriting prototype speed claims."""
import csv
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
NATIVE = {
    "FastPatternBF",
    "FourSectorBloomFilter",
    "Split64BloomFilter",
    "ByteSplitBloomFilter",
}
EXPERIMENTAL = {"FourSector16K8Experimental", "Split64Experimental"}
SEEDS = {"2309", "6311", "10007"}
TIERS = ((16, "0.01"), (16, "0.001"), (32, "0.001"), (32, "0.0001"))
METRICS = ("hash_lookup_ns", "lookup_ns", "hash_insert_ns")


def read(path):
    with path.open() as handle:
        return list(csv.DictReader(handle))


def seed_times(raw, choice, metric):
    return {
        r["seed"]: float(r[metric])
        for r in raw
        if r["keys"] == choice["keys"]
        and r["filter"] == choice["filter"]
        and r["requested_bpk"] == choice["requested_bpk"]
    }


def main():
    sections = []
    records = []
    for language, count in (("cpp", 23), ("rust", 8)):
        directory = ROOT / f"results/2026-10-29-byte-confirmation-{language}"
        raw = read(directory / "results.csv")
        assert len(raw) == count * 12 and {r["seed"] for r in raw} == SEEDS
        assert len({r["filter"] for r in raw}) == count
        metadata = json.loads((directory / "metadata.json").read_text())
        assert (
            metadata["binary_source_revision"]
            == "c4b6a08f41f0256ba6bf901d1701fffa2cd663b8"
        )
        for n in (1 << 16, 1 << 25):
            for bpk in (8, 16):
                for seed in SEEDS:
                    rows = [
                        r
                        for r in raw
                        if int(r["keys"]) == n
                        and int(r["requested_bpk"]) == bpk
                        and r["seed"] == seed
                    ]
                    assert (
                        len(rows) == count and len({r["filter"] for r in rows}) == count
                    )
                    assert all(
                        r["batch"] == "1"
                        and r["repeats"] == "7"
                        and r["queries"] == str(1 << 22)
                        and r["hit_percent"] == "50"
                        and int(r["insert_batch"]) == n
                        and r["calibration_absent_queries"] == str(1 << 24)
                        for r in rows
                    )
        for metric in METRICS:
            rankings = {}
            for cap in (16, 32):
                path = directory / f"{metric}-ranking-{cap}.csv"
                subprocess.run(
                    [
                        sys.executable,
                        str(ROOT / "scripts/rank_external.py"),
                        str(directory / "results.csv"),
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
                rankings[cap] = read(path)
            table = []
            for n in (1 << 16, 1 << 25):
                for cap, target in TIERS:
                    eligible = [
                        r
                        for r in rankings[cap]
                        if int(r["keys"]) == n and r["fpr_target"] == target
                    ]
                    native = min(
                        (r for r in eligible if r["filter"] in NATIVE),
                        key=lambda r: float(r["ns_per_key"]),
                    )
                    external = min(
                        (
                            r
                            for r in eligible
                            if r["filter"] not in NATIVE | EXPERIMENTAL
                        ),
                        key=lambda r: float(r["ns_per_key"]),
                    )
                    nt = float(native["ns_per_key"])
                    et = float(external["ns_per_key"])
                    nn = seed_times(raw, native, metric)
                    ee = seed_times(raw, external, metric)
                    assert nn.keys() == ee.keys() == SEEDS
                    paired = [ee[s] / nn[s] for s in SEEDS]
                    table.append(
                        f"| {n:,} | {cap} / {float(target):.2%} | "
                        f"{native['filter']} | {nt:.3f} | {external['filter']} | "
                        f"{et:.3f} | {et / nt:.3f}× | {min(paired):.3f}–{max(paired):.3f}× |"
                    )
                    records.append(
                        dict(
                            language=language,
                            metric=metric,
                            keys=n,
                            cap=cap,
                            fpr_target=float(target),
                            native=native["filter"],
                            external=external["filter"],
                            native_ns=nt,
                            external_ns=et,
                            speedup=et / nt,
                            paired_min=min(paired),
                            paired_max=max(paired),
                        )
                    )
            title = {
                "hash_lookup_ns": "Hash plus query",
                "lookup_ns": "Prehashed query",
                "hash_insert_ns": "Hash plus construction",
            }[metric]
            sections.append(
                f"## {'C++' if language == 'cpp' else 'Rust'}: {title}\n\n"
                "| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |\n"
                "| --- | --- | --- | --- | --- | --- | --- | --- | --- |\n"
                + "\n".join(table)
            )
    report = (
        """# Native ByteSplit confirmation — 2026-10-29

This stage measures the production C++ and Rust implementations against external
filters under the [preregistered protocol](byte-split-confirmation-protocol-2026-10-29.md).
The C++ suite has **276 rows, 23 configurations × 12 cases**; Rust has **96 rows,
eight configurations × 12 cases**. Each language retains its own timing results.
The selected native leader may be any of the four public layouts; the frozen
Rust prototypes remain controls and are excluded from the external reference.

The native port does not win every single-key workload. C++ ByteSplit improves
small-filter prehashed query by 7–8%, but hash+query is within 0.5–0.9% of the
stronger FastFilter single-call control. Split64 leads the 0.1% FPR band in C++
hash+query by 1.10–1.20×; the selected native leaders lose the strict 0.01% band
and the large-filter 1% band in that metric. Rust retains small-filter losses
against Bloomsday despite some large-filter end-to-end gains. Those losses are
the next optimization targets, not omitted outliers.

Xeon Platinum 8474C, CPU 2, Clang 23/Rust 1.92 with native instructions; matrices run
serially. Sizes are 65K/32M keys, actual native allocations 16/32 bits per key,
50% hits, count 1 through the shared batch API, 2^22 queries and seven repetitions.
Whole-input insertion is independent of query batch size. Seeds 2309/6311/10007
were held out from implementation tuning. Query arrays are warmed and repeated.
This is throughput through that API, not serialized latency or a fused raw-key
single-query API. No new timing-stage output checks are inside the timers.

Each candidate has three disjoint 2^24-negative calibration streams, pooled to
50,331,648 probes. Eligibility requires a pointwise one-sided 95% Wilson upper FPR
bound below the cap and payload allocation at or below the memory ceiling, with
zero slack. Both tested allocations compete when eligible. Bounds are not
simultaneous winner-selection guarantees or per-insertion-set guarantees.

Tables use median-of-seed medians and retain the full range of paired-seed ratios
for the selected native/external configurations. Speedup is external/native;
values below one are native losses. Pure query and hash+query are separate
outcomes; a faster pure kernel need not improve end-to-end work by the same ratio.
Construction includes hashing/insertion, excludes bitmap allocation/zeroing,
and is reported separately. Allocation-inclusive construction is in the raw CSV.

The earlier ByteSplit prototype's approximately 8% end-to-end gain is not reused
as a production claim. Stronger FastFilter single-call controls are retained along
with original paths. The [same-process port check](../experiments/2026-10-29-native-byte-split/integration-report.md)
found native query time within roughly 1.2% of the frozen prototype, while small
construction cases regressed. Compiler/caller context and benchmark changes can
alter these close comparisons. Scoped wins and losses are both retained below.

"""
        + "\n\n".join(sections)
        + """

Rust has two external families; large Rust-only speedups do not imply equivalent
wins against the broader C++ baseline set. PageBloom's optional AES mode and the
full 56-configuration combined suite are outside this 23-candidate C++ shortlist.
Short batches, hit-rate extremes and multithreaded performance are separate
screens. No finite suite proves an unrestricted fastest Bloom filter.

Both executables were built from sources committed in `c4b6a08`. The C++ launch
mistakenly supplied the preceding commit as a metadata flag; the correction keeps
that original flag and records the source/binary digest evidence. The executable
was never rebuilt during timing. See its provenance-correction.json.

[C++ raw data and rankings](../results/2026-10-29-byte-confirmation-cpp/),
[Rust raw data and rankings](../results/2026-10-29-byte-confirmation-rust/),
[complete validation](../experiments/2026-10-29-byte-integration-checks.json).
Regenerate with `python3 scripts/summarize_byte_confirmation.py`.
"""
    )
    (ROOT / "docs/byte-confirmation-2026-10-29.md").write_text(report)
    (ROOT / "results/byte-confirmation-summary.json").write_text(
        json.dumps(records, indent=2) + "\n"
    )
    print("Wrote native ByteSplit confirmation report and all metric rankings")


if __name__ == "__main__":
    main()
