#!/usr/bin/env python3
"""Plot all 288 completed Rust singleton contrasts; requires matplotlib 3.10."""
import csv
import hashlib
import io
from pathlib import Path
from statistics import median

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "experiments/2026-10-29-rust-k12-singleton-internal-analysis/report-v1/pairs.csv"
SOURCE_SHA256 = "8cd39d447b2164e9d33f6222d2e94f978dabdc8a774afb4f8ce83602fbc90739"
CONTRACTS = [
    (1, "generic_pure", "Batch 1 · prehashed"),
    (1, "generic_hash_query", "Batch 1 · hash + query"),
    (1, "visible_pure", "Visible single · prehashed"),
    (1, "visible_hash_query", "Visible single · hash + query"),
    (3, "generic_pure", "Batch 3 · prehashed"),
    (3, "generic_hash_query", "Batch 3 · hash + query"),
    (31, "generic_pure", "Batch 31 · prehashed"),
    (31, "generic_hash_query", "Batch 31 · hash + query"),
    (4096, "generic_pure", "Batch 4096 · prehashed"),
    (4096, "generic_hash_query", "Batch 4096 · hash + query"),
]


def main():
    raw = SOURCE.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SOURCE_SHA256:
        raise ValueError("Completed source comparison changed")
    rows = list(csv.DictReader(io.StringIO(raw.decode())))
    if len(rows) != 288:
        raise ValueError("Incomplete comparison")
    plt.rcParams.update({
        "font.family": "DejaVu Sans", "font.size": 10,
        "svg.fonttype": "none", "svg.hashsalt": "rust-k12-singleton192",
        "axes.spines.top": False, "axes.spines.right": False,
    })
    fig, axes = plt.subplots(2, 2, figsize=(12.6, 10.8), sharex=True, sharey=True)
    fig.patch.set_facecolor("white")
    styles = [(0, "#2066a8", "o", -0.20), (50, "#b45b19", "s", 0),
              (100, "#21835c", "^", 0.20)]
    plotted = 0
    for row_index, profile in enumerate(("native", "portable")):
        for column, (power, size) in enumerate(((16, "65,536 keys · 192 KiB"),
                                               (25, "33,554,432 keys · 96 MiB"))):
            ax = axes[row_index, column]
            for y, (batch, mode, _) in enumerate(CONTRACTS):
                for hit, color, marker, offset in styles:
                    if batch != 1 and hit != 50:
                        continue
                    selected = [r for r in rows if r["profile"] == profile
                                and int(r["key_power"]) == power and int(r["hit"]) == hit
                                and int(r["batch"]) == batch and r["mode"] == mode]
                    if len(selected) != 4 or {(int(r["seed"]), int(r["round"])) for r in selected} != {
                        (6812364731, 1), (6812364731, 2), (9517218469, 1), (9517218469, 2)
                    }:
                        raise ValueError("Missing or duplicated seed/round point")
                    values = [float(r["latency_ratio"]) for r in selected]
                    center = median(values)
                    ax.errorbar(center, y + offset,
                                xerr=[[center - min(values)], [max(values) - center]],
                                color=color, marker=marker, markersize=4, capsize=2,
                                linewidth=1.4, label=f"{hit}% hits" if y == 0 else None)
                    plotted += len(values)
            ax.axvline(1, color="#666666", linestyle="--", linewidth=1)
            ax.axvspan(1, 1.06, color="#b45b19", alpha=0.06)
            ax.set_xlim(0.40, 1.06)
            ax.set_xticks([0.4, 0.6, 0.8, 1.0])
            ax.set_ylim(9.65, -0.65)
            ax.set_title(f"{profile.title()} · {size}", loc="left", fontweight="bold", pad=12)
            ax.set_xlabel("Candidate / same-profile control latency · lower is faster")
            ax.tick_params(axis="x", labelbottom=True)
            ax.grid(axis="x", color="#e2e6ea", linewidth=0.7)
            for y in [3.5, 5.5, 7.5]:
                ax.axhline(y, color="#e2e6ea", linewidth=0.7)
    if plotted != len(rows):
        raise ValueError("Not every comparison was plotted")
    axes[0, 0].set_yticks(range(len(CONTRACTS)), [c[2] for c in CONTRACTS])
    handles, labels = axes[0, 0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="upper right", bbox_to_anchor=(0.985, 0.965),
               frameon=False, ncol=3)
    fig.suptitle("Rust K12 singleton SIMD: gains and regressions in both build profiles",
                 x=0.03, y=0.985, ha="left", fontsize=15, fontweight="bold")
    fig.text(0.03, 0.94, "Each profile uses its own safe SingleLine control; these are not absolute speed comparisons between builds.", fontsize=10)
    fig.text(0.03, 0.047, "Points: median of 2 seeds × 2 opposite launch rounds. Bars: full observed range, not confidence intervals.", fontsize=10)
    fig.text(0.03, 0.025, "All 288 contrasts · 24 actual bits/key · Xeon 8474C / AVX-512 · Internal query comparison; no external ranking.", fontsize=10)
    fig.subplots_adjust(left=0.24, right=0.98, top=0.88, bottom=0.12, wspace=0.10, hspace=0.35)
    output = ROOT / "docs/figures/rust-k12-singleton.svg"
    fig.savefig(output, metadata={"Date": None, "Creator": "scripts/plot_rust_k12_singleton.py"})
    output.write_text("\n".join(line.rstrip() for line in output.read_text().splitlines()) + "\n")
    print(f"Plotted all {plotted} contrasts to {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
