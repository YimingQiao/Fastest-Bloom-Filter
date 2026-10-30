#!/usr/bin/env python3
"""Plot every completed C++ singleton192 comparison; requires matplotlib 3.10."""
import csv
import hashlib
import io
from pathlib import Path
from statistics import median

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "experiments/2026-10-29-k12-singleton-vector-analysis/report-v1/pairs.csv"
SOURCE_SHA256 = "58b3411a7034d54fc1d0a9102e7f7ea0b07dfa6329c1557060d8c4f7680e4422"
CONTRACTS = [
    (1, "generic_pure", "Batch 1 · prehashed"),
    (1, "generic_staged_common_hash", "Batch 1 · hash + query"),
    (1, "visible_public_pure", "Visible single · prehashed"),
    (1, "visible_public_fused_common_hash", "Visible single · hash + query"),
    (3, "generic_pure", "Batch 3 · prehashed"),
    (3, "generic_staged_common_hash", "Batch 3 · hash + query"),
    (31, "generic_pure", "Batch 31 · prehashed"),
    (31, "generic_staged_common_hash", "Batch 31 · hash + query"),
    (4096, "generic_pure", "Batch 4096 · prehashed"),
    (4096, "generic_staged_common_hash", "Batch 4096 · hash + query"),
]


def main():
    raw = SOURCE.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SOURCE_SHA256:
        raise ValueError("Completed source comparison changed")
    rows = list(csv.DictReader(io.StringIO(raw.decode())))
    if len(rows) != 240:
        raise ValueError("Incomplete comparison")
    plt.rcParams.update({
        "font.family": "DejaVu Sans", "font.size": 10,
        "svg.fonttype": "none", "svg.hashsalt": "k12-singleton192",
        "axes.spines.top": False, "axes.spines.right": False,
    })
    fig, axes = plt.subplots(1, 2, figsize=(12.4, 7), sharey=True)
    fig.patch.set_facecolor("white")
    styles = [(0, "#2066a8", "o", -0.20), (50, "#b45b19", "s", 0),
              (100, "#21835c", "^", 0.20)]
    plotted = 0
    for ax, power, title in zip(axes, (16, 25), ("65,536 keys · 192 KiB", "33,554,432 keys · 96 MiB")):
        for y, (batch, mode, _) in enumerate(CONTRACTS):
            for hit, color, marker, offset in styles:
                selected = [r for r in rows if int(r["n_exponent"]) == power
                            and int(r["hit"]) == hit and int(r["batch"]) == batch
                            and r["mode"] == mode]
                if len(selected) != 4 or {(int(r["seed"]), int(r["round"])) for r in selected} != {
                    (16057, 1), (16057, 2), (32029, 1), (32029, 2)
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
        ax.axvspan(1, 1.08, color="#b45b19", alpha=0.06)
        ax.set_xlim(0.38, 1.08)
        ax.set_xticks([0.4, 0.6, 0.8, 1.0])
        ax.set_ylim(9.65, -0.65)
        ax.set_title(title, loc="left", fontweight="bold", pad=12)
        ax.set_xlabel("Candidate / old K12 latency · lower is faster")
        ax.grid(axis="x", color="#e2e6ea", linewidth=0.7)
        for y in [3.5, 5.5, 7.5]:
            ax.axhline(y, color="#e2e6ea", linewidth=0.7)
    if plotted != len(rows):
        raise ValueError("Not every comparison was plotted")
    axes[0].set_yticks(range(len(CONTRACTS)), [c[2] for c in CONTRACTS])
    axes[1].legend(loc="upper left", frameon=False)
    fig.suptitle("C++ K12 singleton SIMD: small-query gains, mixed bulk results",
                 x=0.03, y=0.98, ha="left", fontsize=16, fontweight="bold")
    fig.text(0.03, 0.055, "Points: median of 2 seeds × 2 opposite launch rounds. Bars: full observed range, not confidence intervals.", fontsize=10)
    fig.text(0.03, 0.025, "All 240 contrasts · 24 actual bits/key · Xeon 8474C / AVX-512 · Internal comparison; external confirmation pending.", fontsize=10)
    fig.subplots_adjust(left=0.24, right=0.98, top=0.86, bottom=0.16, wspace=0.10)
    output = ROOT / "docs/figures/k12-singleton.svg"
    fig.savefig(output, metadata={"Date": None, "Creator": "scripts/plot_k12_singleton.py"})
    output.write_text("\n".join(line.rstrip() for line in output.read_text().splitlines()) + "\n")
    print(f"Plotted all {plotted} contrasts to {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
