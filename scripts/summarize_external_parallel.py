#!/usr/bin/env python3
"""Publish the frozen eight-core comparison without mixing timing contracts."""
import csv
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "experiments/2026-10-29-external-parallel-query/confirmation8"
TIERS = [(16, 0.01), (16, 0.001), (32, 0.001), (32, 0.0001)]
NAMES = {
    "FastPatternBF": "FastPattern",
    "FourSectorBloomFilter": "FourSector",
    "FastFilterSimdBlock": "FastFilter SIMD",
    "FastFilterSimdBlockSingleV1": "FastFilter SIMD SingleV1",
    "FastFilterFixed64": "FastFilter Fixed64",
    "Boost192Multi32K8": "Boost Multi32K8",
    "Boost192Multi64K8": "Boost Multi64K8",
}


def load():
    freeze = json.loads((ARCHIVE / "FREEZE.json").read_text())
    for name, digest in freeze["files"].items():
        if hashlib.sha256((ARCHIVE / name).read_bytes()).hexdigest() != digest:
            raise ValueError(f"Frozen confirmation file changed: {name}")
    data = json.loads((ARCHIVE / "results/summary.json").read_text())
    with (ARCHIVE / "results/results.csv").open() as stream:
        rows = list(csv.DictReader(stream))
    if len(rows) != 276 or {int(r["threads"]) for r in rows} != {8}:
        raise ValueError("Expected 276 eight-core rows")
    if {int(r["seed"]) for r in rows} != {19867, 45631, 93187}:
        raise ValueError("Unexpected confirmation seeds")
    quality = data["pooled_calibration"]
    if len(quality) != 92 or any(q["queries"] != 50331648 for q in quality):
        raise ValueError("Unexpected calibration pooling")
    return data


def selected(data, n, tier, metric):
    rows = [
        r
        for r in data["comparisons"]
        if int(r["case"]["keys"]) == n
        and (r["memory_cap_bpk"], r["fpr_target"]) == tier
        and r["metric"] == metric
    ]
    if len(rows) != 1:
        raise ValueError("Ambiguous comparison")
    r = rows[0]
    for side in ("native", "external"):
        if not r[f"{side}_all_seed_quality_uppers_pass"]:
            raise ValueError("Selected configuration fails a seed quality bound")
    return r


def report(data):
    lines = [
        "# External comparison on eight physical cores",
        "",
        "The native C++ portfolio leads the eligible external shortlist in every reported "
        "query cell, on all three fresh seeds. Including common hashing, fresh thread "
        "creation, pinning and joining, the fixed-pair speedups range from **1.060–1.589×** "
        "across paired seeds. This result covers batch 4096, 50% hits, 65,536/33,554,432 "
        "inserted keys, and eight physical cores of one Xeon Platinum 8474C. It does not "
        "establish a universal fastest filter or an external multithreaded Rust result.",
        "",
        "![Eight-core external comparison](figures/external-parallel-confirmation.svg)",
        "",
        "## Hashing plus query, including fresh threads",
        "",
        "Each row fixes the native and external configurations using the median of three "
        "seed medians. Latencies are elapsed nanoseconds per query across all eight cores, "
        "not per-key dependent latency. Speedup is external/native; the range compares "
        "the same pair on each seed. The plot's center is the median paired-seed speedup.",
        "",
        "| Keys | Memory cap | FPR ceiling | Native leader | ns/query | External leader | ns/query | Speedup | Paired range |",
        "| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: | ---: |",
    ]
    for n in (65536, 33554432):
        for tier in TIERS:
            r = selected(data, n, tier, "parallel_hash_lookup_end_to_end_ns")
            a, b = r["native"], r["external"]
            lines.append(
                f"| {n:,} | {tier[0]} bits/key | {tier[1]:.2%} | "
                f"{NAMES.get(a['filter'], a['filter'])} ({a['actual_bpk']:.0f} bpk) | "
                f"{a['median_of_seed_medians_ns']:.3f} | "
                f"{NAMES.get(b['filter'], b['filter'])} | "
                f"{b['median_of_seed_medians_ns']:.3f} | {r['aggregate_speedup']:.3f}× | "
                f"{r['paired_speedup_min']:.3f}–{r['paired_speedup_max']:.3f}× |"
            )
    lines += [
        "",
        "The conservative comparison against the fastest pooled-quality-eligible external "
        "chosen separately for each seed also stays above 1.060×. All four query metrics "
        "are retained: prehashed and hash-plus-query, each with a synchronized kernel "
        "interval and a fresh-thread end-to-end interval. The kernel interval includes "
        "worker wakeup and completion synchronization. End-to-end additionally includes "
        "launch, affinity setup, joining and destruction; preallocated input/output/hash "
        "scratch is outside both timers and its bytes are reported.",
        "",
        "## Contract and eligibility",
        "",
        "The 56-configuration executable ran the prespecified 23-configuration shortlist: "
        "four native layouts plus pinned FastFilter, PageBloomFilter, Boost.Bloom and "
        "RocksDB core configurations. Every filter uses one shared immutable bitmap, "
        "the same eight physical cores, identical queries and dense outputs, and the same "
        "global query-batch boundaries. The caller is worker zero; seven other threads "
        "are created. Construction remains serial and separately measured. This does not "
        "compare concurrent insertion algorithms or eight bitmap replicas.",
        "",
        "All 12 workloads / 276 rows completed with five repetitions and unchanged source "
        "and binary hashes. Seeds 19867, 45631 and 93187 contribute 50,331,648 independent "
        "negative probes per exact filter/allocation configuration. Raw negative intervals "
        "are disjoint. Repeated timing controls do not multiply the calibration sample size. "
        "Eligibility uses exact payload allocation with no slack and the **upper endpoint "
        "of a two-sided 95% Wilson interval** (z=1.959964), a stricter bound than the earlier "
        "single-thread report's one-sided 95% bound. These are pointwise quality intervals, "
        "not simultaneous guarantees after winner selection. Both measured allocations "
        "can compete below a cap; a 32-bpk cap can select a 16-bpk filter. No measured "
        "configuration qualifies for 0.01% FPR under the 16-bpk cap.",
        "",
        "All selected pairs also pass their target on every seed separately. Qualification "
        "near a boundary remains seed-sensitive: small FastPattern at 32 bpk failed 0.01% "
        "in the earlier seed-42 screen, but passes all three new seeds (pooled upper "
        "0.009436%). Large FourSector at 16 bpk similarly changes from an earlier screen "
        "failure to passing 0.1% on every fresh seed (pooled upper 0.098575%). Both earlier "
        "failures are preserved; these measurements are not input-independent FPR promises.",
        "",
        "## Remaining losses and validation",
        "",
        "Choosing a portfolio leader does not make every native layout faster. Large "
        "ByteSplit at 16 bpk loses to Boost Multi32K8 in the gated hash-plus-query metric "
        "(0.935–0.954× paired speedups); small Split64 loses in the loose 1% tier "
        "(0.802–0.820×). Individual-family rankings retain these losses. Single-key and "
        "irregular batches require their own comparisons.",
        "",
        "The harness validates complete dense output and checksums outside every timed "
        "trial, all inserted keys, disjoint output ownership and global tails. Native, "
        "ASan/UBSan and TSan checks cover representative filters, launch failures, worker "
        "exceptions, affinity failures and cleanup. Full-registry parity covers all 56 "
        "configurations. Eleven confirmation-analysis regression tests pass. The 1/4-core "
        "runs remain exploratory; same-row serial controls in this confirmation independently "
        "report native scaling. Observed ratios slightly above eight do not prove "
        "algorithmic superlinear scaling.",
        "",
        "## Reproduce and inspect",
        "",
        "The [frozen protocol](../experiments/2026-10-29-external-parallel-query/confirmation8/protocol.json), "
        "[complete four-metric report](../experiments/2026-10-29-external-parallel-query/confirmation8/RESULTS.md), "
        "[raw CSV](../experiments/2026-10-29-external-parallel-query/confirmation8/results/results.csv), "
        "[paired-seed details](../experiments/2026-10-29-external-parallel-query/confirmation8/results/paired-seed-comparison.csv) "
        "and [reproduction commands](../experiments/2026-10-29-external-parallel-query/confirmation8/README.md) "
        "retain every rival, allocation and timing sample. The measured framework is "
        "`b437791b6edf23fe8725f87e62d21d638216861a`; its binary SHA-256 is "
        "`f39ddeab1538c812bea663110a4b1eba14eaf29694014533e3e9b08cacd3cbdb`. "
        "Regenerate this document and plot with `python3 scripts/summarize_external_parallel.py` "
        "(matplotlib required).",
        "",
    ]
    (ROOT / "docs/external-parallel-confirmation-2026-10-29.md").write_text(
        "\n".join(lines)
    )


def plot(data):
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    matplotlib.rcParams.update(
        {"svg.hashsalt": "external-parallel-confirmation", "font.size": 10}
    )
    fig, axes = plt.subplots(1, 2, figsize=(11, 3.7), sharex=True, sharey=True)
    modes = [
        (
            "parallel_hash_lookup_end_to_end_ns",
            "Including fresh threads",
            "#167a62",
            -0.12,
        ),
        (
            "parallel_hash_lookup_gated_ns",
            "Synchronized query interval",
            "#4269b0",
            0.12,
        ),
    ]
    for ax, n, title in zip(
        axes, (65536, 33554432), ("65,536 keys", "33,554,432 keys")
    ):
        for metric, label, color, offset in modes:
            rows = [selected(data, n, tier, metric) for tier in TIERS]
            centers = [r["paired_median_speedup"] for r in rows]
            low = [c - r["paired_speedup_min"] for c, r in zip(centers, rows)]
            high = [r["paired_speedup_max"] - c for c, r in zip(centers, rows)]
            ax.errorbar(
                centers,
                [i + offset for i in range(4)],
                xerr=[low, high],
                fmt="o",
                capsize=3,
                color=color,
                label=label,
            )
        ax.axvline(1, color="#9b4444", linestyle="--", linewidth=1)
        ax.set_title(title)
        ax.set_xlim(0.98, 1.78)
        ax.set_xlabel("External / native query time (higher is faster)")
        ax.grid(axis="x", alpha=0.2)
        ax.spines[["top", "right"]].set_visible(False)
    axes[0].set_yticks(
        range(4),
        [
            "16 bpk · FPR ≤ 1%",
            "16 bpk · FPR ≤ 0.1%",
            "32 bpk · FPR ≤ 0.1%",
            "32 bpk · FPR ≤ 0.01%",
        ],
    )
    axes[0].invert_yaxis()
    fig.suptitle(
        "Eight-core hash + query: three fresh seeds, identical memory/FPR limits",
        fontsize=12,
    )
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="lower center", ncol=2, frameon=False)
    fig.tight_layout(rect=(0, 0.10, 1, 0.94))
    fig.savefig(
        ROOT / "docs/figures/external-parallel-confirmation.svg",
        metadata={"Date": None},
    )
    plt.close(fig)


if __name__ == "__main__":
    frozen = load()
    report(frozen)
    plot(frozen)
    print("Verified the frozen 276-row confirmation and wrote report/figure")
