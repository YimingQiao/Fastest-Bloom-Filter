#!/usr/bin/env python3
"""Render the frozen large-batch confirmation; never mix screening into its ranking."""
import csv
from pathlib import Path
from statistics import median

ROOT = Path(__file__).resolve().parents[1]
OURS = {
    "FastPatternBF",
    "FastPattern64Experiment",
    "FourSector16K8",
    "Split64P32",
    "FourSector16K8Experimental",
    "Split64Experimental",
}


def read(path):
    with path.open() as f:
        return list(csv.DictReader(f))


def main():
    sections = []
    chart = []
    for language, expected_rows in (("cpp", 234), ("rust", 90)):
        directory = ROOT / f"results/2026-10-28-modern-confirmation-{language}"
        raw = read(directory / "results.csv")
        assert len(raw) == expected_rows, "confirmation matrix must be complete"
        assert {r["seed"] for r in raw} == {"307", "509", "1021"}
        assert all(int(r["calibration_absent_queries"]) == 1 << 24 for r in raw)
        rows = []
        for cap, target in ((16, "0.01"), (16, "0.001"), (32, "0.0001")):
            ranking = read(directory / f"ranking-{cap}.csv")
            for keys in (1 << 16, 1 << 24, 1 << 25):
                eligible = [
                    r
                    for r in ranking
                    if int(r["keys"]) == keys and r["fpr_target"] == target
                ]
                native = min(
                    (r for r in eligible if r["filter"] in OURS),
                    key=lambda r: float(r["ns_per_key"]),
                )
                external = min(
                    (r for r in eligible if r["filter"] not in OURS),
                    key=lambda r: float(r["ns_per_key"]),
                )
                ratio = float(external["ns_per_key"]) / float(native["ns_per_key"])
                rows.append(
                    f"| {keys:,} | {cap} | {float(target):.2%} | {native['filter']} | {float(native['ns_per_key']):.3f} | {external['filter']} | {float(external['ns_per_key']):.3f} | {ratio:.2f}× |"
                )
                if language == "cpp":
                    chart.append(
                        (
                            keys,
                            cap,
                            float(target),
                            ratio,
                            native["filter"],
                            external["filter"],
                        )
                    )
        sections.append(
            f"## {language.upper()} large-batch queries\n\n"
            "Each row chooses the lowest median hash+query time among eligible configurations.\n"
            "The external reference is the fastest eligible external configuration in this suite.\n\n"
            "| Keys | Memory ceiling, bits/key | FPR ceiling | Our candidate | ns/key | External reference | ns/key | Speedup |\n"
            "| --- | --- | --- | --- | --- | --- | --- | --- |\n" + "\n".join(rows)
        )
        # Construction of the query winner is a separate metric, including its losses.
        if language == "cpp":
            sections.append(
                "Rust has two external families; C++ has the broader baseline set. A large Rust-only\n"
                "ratio can result from fastbloom being the only eligible external family at 16 bits/key\n"
                "and 0.1% FPR. It does not mean that Rust beats the fastest C++ baseline by that ratio."
            )
    build = []
    raw = read(ROOT / "results/2026-10-28-modern-confirmation-cpp/results.csv")
    for keys in (1 << 16, 1 << 24, 1 << 25):
        for name in (
            "FourSector16K8",
            "Split64P32",
            "Boost192Multi64K8",
            "FastFilterFixed64",
        ):
            rr = [
                r
                for r in raw
                if int(r["keys"]) == keys
                and r["requested_bpk"] == "8"
                and r["filter"] == name
            ]
            assert len(rr) == 3
            build.append(
                f"| {keys:,} | {name} | {median(float(r['hash_insert_ns']) for r in rr):.3f} |"
            )
    report = (
        """# Modern external confirmation — 2026-10-28

The frozen large-batch stage confirms a query lead for our candidates in every
scenario with eligible configurations in the measured suites. This is a bounded
result, not a claim of an unrestricted fastest Bloom filter. Single-key, short
batches, hit-rate extremes and new-layout parallel scaling are separate work.

The C++ matrix has **234 rows: 13 candidates × 18 cases**. The Rust matrix has
**90 rows: five candidates × the same 18 cases**. Candidate selection preceded
these measurements; insertion seeds 307, 509 and 1021 were held out. All inserted
keys are validated, and cross-language candidate bitmap/checksum parity is checked
separately. See the [frozen protocol](confirmation-protocol-2026-10-28.md).

Host: Xeon Platinum 8474C, one thread pinned to CPU 2; Clang 23 and Rust 1.92,
native instructions. The suites ran serially. Each seed has 2^22 timed queries,
50% hits, batch 4096, whole-input build calls and five timing repetitions. Rows
report the median of seed medians, not the best repetition. Allocation spans
128 KiB–128 MiB; the latter exceeds one socket's 97.5 MiB LLC, but repeated query
access is not guaranteed cold. Hardware/compiler/API details limit generalization.

Eligibility uses an explicit resident-allocation ceiling, zero byte slack, and
a pointwise one-sided 95% Wilson upper FPR bound. Each configuration pools three
disjoint 2^24-negative calibration streams (50,331,648 samples), after timing.
These are separate insertion seeds, not repeated counts of the timed queries.
Different configurations can use different bytes within a ceiling; exact bytes
and confidence bounds remain in the rankings. At the 16 bits/key ceiling no tested
configuration qualifies for 0.01% FPR, so that target is shown at 32 bits/key.
Pointwise bounds are not simultaneous confidence guarantees for every selected rank.

![C++ query speedup against the fastest eligible external baseline](figures/modern-confirmation.svg)

"""
        + "\n\n".join(sections)
        + """

## Construction remains a separate tradeoff

The following are median **hash+insert ns/key**, using the same actual 16 bits/key
allocation ceiling and the four configurations eligible for 0.1% FPR. They include
hashing and insertion, and exclude bitmap allocation/zeroing; the CSV also retains
allocate+hash+insert. FourSector's query advantage does not make it the fastest
builder. Split64 and the external filters remain useful construction comparators.

| Keys | Candidate | Hash+insert ns/key |
| --- | --- | --- |
"""
        + "\n".join(build)
        + """

The complete screen included 42 external C++ configurations. This confirmation
uses its shortlist, not every implementation ever published. The wider dictionary
is still experimental; production FourSector/Split64 integration and subsequent
optimizations require their own correctness and timing checks. The optional
PageBloom AES screen is retained separately and is not mixed into these medians.

[C++ raw data and provenance](../results/2026-10-28-modern-confirmation-cpp/),
[Rust raw data and provenance](../results/2026-10-28-modern-confirmation-rust/),
[C++ 16-bit ranking](../results/2026-10-28-modern-confirmation-cpp/ranking-16.csv),
[C++ 32-bit ranking](../results/2026-10-28-modern-confirmation-cpp/ranking-32.csv),
[baseline source/API contracts](../benchmarks/all-external/README.md).
"""
    )
    (ROOT / "docs/modern-confirmation-2026-10-28.md").write_text(report)
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, axes = plt.subplots(1, 3, figsize=(11, 3.3), sharey=True)
    for ax, (cap, target) in zip(axes, ((16, 0.01), (16, 0.001), (32, 0.0001))):
        rr = [x for x in chart if x[1] == cap and x[2] == target]
        values = [x[3] for x in rr]
        bars = ax.bar(["65K", "16M", "32M"], values, color="#236c9c", width=0.6)
        ax.axhline(1, color="#64748b", linestyle="--", linewidth=1)
        ax.bar_label(bars, labels=[f"{v:.2f}×" for v in values], padding=4)
        ax.set_title(f"FPR ≤ {target:.2%}; ≤ {cap} bits/key", fontsize=10)
        ax.set_xlabel("Inserted keys")
        ax.set_ylim(0, 2)
        ax.spines[["top", "right"]].set_visible(False)
    axes[0].set_ylabel("Hash+query speedup vs external leader")
    fig.suptitle(
        "Held-out C++ large-batch confirmation · Xeon 8474C · 3 seeds", fontsize=12
    )
    fig.tight_layout()
    for suffix in ("svg", "png"):
        fig.savefig(ROOT / f"docs/figures/modern-confirmation.{suffix}", dpi=160)
    print("Wrote confirmation report and figure")


if __name__ == "__main__":
    main()
