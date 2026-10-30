#!/usr/bin/env python3
"""Supplementary descriptive capacity frontiers from a complete validated screen."""
import argparse
import hashlib
import json
import math
from pathlib import Path

from summarize_exact_budget import (
    DEFAULT_EXPERIMENT,
    eligible,
    enrich,
    fastest,
    verify_archive,
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--experiment", type=Path, default=DEFAULT_EXPERIMENT)
    parser.add_argument("--archive", type=Path)
    args = parser.parse_args()
    experiment = args.experiment.resolve()
    archive = (args.archive or experiment / "screen").resolve()
    rows, protocol, metadata = verify_archive(experiment, archive)
    records, _ = enrich(rows)
    caps = protocol["budget_bpk"]
    sizes = sorted({row["keys"] for row in records})
    tiers = protocol["quality_caps"]
    groups = [
        ("production_native", "Production native", "#1473b7", "o"),
        ("external", "Best external", "#c96522", "s"),
        ("project_experiment", "Range experiments", "#26824e", "^"),
    ]
    metric = "hash_lookup_ns"
    frontiers = []
    for n in sizes:
        candidates = [row for row in records if row["keys"] == n]
        for tier in tiers:
            for origin, _, _, _ in groups:
                for cap in caps:
                    choice = fastest(
                        [row for row in candidates if eligible(row, cap, tier, metric)],
                        {origin},
                        metric,
                    )
                    frontiers.append(
                        dict(
                            keys=n,
                            fpr_ceiling=tier,
                            origin=origin,
                            memory_cap_bpk=cap,
                            winner=(
                                {
                                    name: choice[name]
                                    for name in (
                                        "filter",
                                        "configuration_id",
                                        "filter_bytes",
                                        "actual_bpk",
                                        "observed_fpr",
                                        "quality_upper",
                                        metric,
                                    )
                                }
                                if choice
                                else None
                            ),
                        )
                    )
    # This supplementary view was chosen after the small-case screen began.
    # The prespecified16/32-cap rankings remain in the separate main report.
    evidence = dict(
        scope="Supplementary descriptive frontiers at all seven measured caps; post-hoc visualization, no held-out claim",
        selection="Fastest measured fitting allocation per group under pointwise two-sided95 Wilson upper FPR bound; smaller fitting allocations remain eligible",
        source_commit=metadata["source_commit"],
        results_sha256=hashlib.sha256(
            (archive / "results.csv").read_bytes()
        ).hexdigest(),
        analysis_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        frontiers=frontiers,
    )

    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from matplotlib.ticker import ScalarFormatter

    plt.rcParams.update(
        {
            "font.family": "DejaVu Sans",
            "font.size": 10,
            "svg.hashsalt": "exact-capacity-2026-10-29",
            "axes.spines.top": False,
            "axes.spines.right": False,
        }
    )
    fig, axes = plt.subplots(len(sizes), len(tiers), figsize=(12.6, 7), squeeze=False)
    for i, n in enumerate(sizes):
        for j, tier in enumerate(tiers):
            ax = axes[i, j]
            panel_values = []
            for origin, label, color, marker in groups:
                points = [
                    item
                    for item in frontiers
                    if item["keys"] == n
                    and item["fpr_ceiling"] == tier
                    and item["origin"] == origin
                ]
                values = [
                    item["winner"][metric] if item["winner"] else float("nan")
                    for item in points
                ]
                panel_values.extend(value for value in values if math.isfinite(value))
                ax.plot(
                    caps,
                    values,
                    color=color,
                    marker=marker,
                    markersize=4,
                    linewidth=1.5,
                    label=label,
                    drawstyle="steps-post",
                )
            ax.set_title(f"{n:,} keys · FPR ≤ {tier:.2%}")
            ax.set_xticks(caps)
            ax.set_xlim(min(caps) - 0.6, max(caps) + 0.6)
            ax.set_yscale("log")
            # A tightly cropped axis would exaggerate sub-percent differences.
            # Preserve at least a twofold vertical span in every panel.
            if panel_values and max(panel_values) / min(panel_values) < 2:
                midpoint = math.sqrt(min(panel_values) * max(panel_values))
                ax.set_ylim(midpoint / math.sqrt(2) * 0.95, midpoint * math.sqrt(2) * 1.05)
            ax.yaxis.set_major_formatter(ScalarFormatter())
            ax.yaxis.set_minor_formatter(ScalarFormatter())
            ax.grid(axis="y", which="both", alpha=0.18)
            ax.set_xlabel("Memory ceiling (bits/key)")
            if j == 0:
                ax.set_ylabel("Hash + query (ns/key, log scale)")
    handles, labels = axes[0, 0].get_legend_handles_labels()
    fig.legend(
        handles,
        labels,
        loc="upper center",
        ncol=3,
        bbox_to_anchor=(0.5, 0.94),
        frameon=False,
    )
    fig.suptitle("Measured capacity frontier · lower is faster", fontsize=16, y=0.985)
    fig.text(
        0.5,
        0.025,
        "One-seed training screen · CPU2 · batch 4096 · 50% hits · actual backing bytes · gaps mean no qualifier\n"
        "Each step selects among measured allocations; it does not predict unmeasured capacities. Range types remain experimental.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0.02, 0.075, 1, 0.9), h_pad=1.7, w_pad=1.8)
    fig.savefig(archive / "capacity-frontier.svg", metadata={"Date": None})
    fig.savefig(
        archive / "capacity-frontier.png", dpi=160, metadata={"Software": "matplotlib"}
    )
    evidence["matplotlib_version"] = matplotlib.__version__
    (archive / "capacity-frontier.json").write_text(
        json.dumps(evidence, indent=2) + "\n"
    )
    (archive / "CAPACITY-FRONTIER.md").write_text(
        "# Supplementary capacity frontier\n\n"
        "![Measured memory and hash-query tradeoffs](capacity-frontier.svg)\n\n"
        "This descriptive view selects the fastest measured allocation fitting each "
        "of the seven memory ceilings, separately for production natives, external "
        "implementations and project range experiments. Lower is faster; the vertical "
        "axis is logarithmic. A missing point means that group has no measured "
        "configuration passing the memory and FPR gates. Steps describe the best "
        "available measured allocation, not an interpolation of unmeasured filters.\n\n"
        "The visualization was planned after the small-table measurements began. "
        "It supplements the prespecified 16/32-bpk rankings in [RESULTS.md](RESULTS.md); "
        "it is exploratory training evidence, with pointwise FPR bounds and no "
        "simultaneous winner-selection or held-out speed guarantee. "
        "[capacity-frontier.json](capacity-frontier.json) retains every selected "
        "configuration, its actual bytes, quality bound, timing and source provenance.\n"
    )
    print(f"Validated {len(rows)} rows; rendered {len(frontiers)} frontier records")


if __name__ == "__main__":
    main()
