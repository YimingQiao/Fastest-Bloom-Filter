#!/usr/bin/env python3
"""Draw README figures from raw CSV; requires matplotlib (tested with 3.10)."""
import csv
from pathlib import Path
from statistics import median
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter

ROOT = Path(__file__).resolve().parents[1]
DATE = "2026-10-28"


def read(name):
    with (ROOT / "results" / f"{DATE}-{name}" / "results.csv").open() as f:
        return list(csv.DictReader(f))


def key(r):
    return tuple(
        r[k] for k in ["keys", "requested_bpk", "hit_percent", "batch", "seed"]
    )


def main():
    plt.rcParams.update(
        {
            "font.family": "DejaVu Sans",
            "font.size": 11,
            "svg.fonttype": "none",
            "svg.hashsalt": "fastest-bf-20261028",
            "axes.spines.top": False,
            "axes.spines.right": False,
        }
    )
    fig, axes = plt.subplots(
        1, 2, figsize=(12.8, 5.5), gridspec_kw={"width_ratios": [1, 1.25]}
    )
    fig.patch.set_facecolor("#ffffff")
    colors = {"C++": "#2166ac", "Rust": "#d56524"}
    cpp = read("cpp")
    reference = {}
    for r in cpp:
        if r["filter"] in ("CacheSectorizedBF32Bit", "NewCacheSectorizedBF32Bit"):
            reference.setdefault(key(r), []).append(r)
    for j, (lang, source) in enumerate([("C++", cpp), ("Rust", read("rust"))]):
        vals = []
        for power in [12, 16, 20, 24, 25]:
            selected = [
                r
                for r in source
                if r["filter"] == "FastPatternBF"
                and int(r["keys"]) == 2**power
                and r["requested_bpk"] == "8"
            ]
            vals.append(
                median(
                    min(
                        float(b["lookup_ns"])
                        for b in reference[key(r)]
                        if b["filter_bytes"] == r["filter_bytes"]
                    )
                    / float(r["lookup_ns"])
                    for r in selected
                )
            )
        bars = axes[0].barh(
            [i + (j - 0.5) * 0.34 for i in range(5)],
            vals,
            height=0.3,
            color=colors[lang],
            label=lang,
        )
        axes[0].bar_label(
            bars, labels=[f"{v:.2f}×" for v in vals], padding=4, fontsize=10
        )
    axes[0].set_yticks(range(5), ["8 KiB", "128 KiB", "2 MiB", "32 MiB", "64 MiB"])
    axes[0].invert_yaxis()
    axes[0].set_xlim(0, 1.8)
    axes[0].axvline(1, color="#666666", linestyle="--", linewidth=1)
    axes[0].set_xlabel("Query throughput / original C++ sectorized")
    axes[0].set_ylabel("Bitmap payload")
    axes[0].set_title(
        "Single thread · 16 actual bits/key", loc="left", fontsize=13, fontweight="bold"
    )
    axes[0].legend(loc="lower right", frameon=False)
    for lang, suffix in [("C++", "cpp"), ("Rust", "rust")]:
        source = read("parallel-" + suffix)
        vals = []
        for t in [1, 2, 4, 8, 16, 32]:
            rr = [
                r for r in source if r["keys"] == str(2**25) and int(r["threads"]) == t
            ]
            serial = {r["seed"]: r for r in rr if r["filter"] == "FastPatternSerial"}
            part = [r for r in rr if r["filter"] == "FastPatternPartitioned"]
            vals.append(
                median(
                    float(serial[r["seed"]]["lookup_ns"]) / float(r["lookup_ns"])
                    for r in part
                )
            )
        axes[1].plot(
            [1, 2, 4, 8, 16, 32],
            vals,
            marker="o",
            linewidth=2.2,
            color=colors[lang],
            label=lang,
        )
    axes[1].set_xscale("log", base=2)
    axes[1].set_xticks([1, 2, 4, 8, 16, 32], ["1", "2", "4", "8", "16", "32"])
    axes[1].set_ylim(0, 16)
    axes[1].yaxis.set_major_formatter(FuncFormatter(lambda x, _: f"{x:g}×"))
    axes[1].grid(axis="y", color="#e1e5eb", linewidth=0.7)
    axes[1].set_xlabel("Physical cores on one socket")
    axes[1].set_ylabel("Query throughput / same-language serial")
    axes[1].set_title(
        "Parallel queries · 128 MiB bitmap", loc="left", fontsize=13, fontweight="bold"
    )
    axes[1].legend(loc="upper left", frameon=False)
    fig.suptitle(
        "FastPattern on Intel Xeon Platinum 8474C · AVX-512",
        x=0.05,
        ha="left",
        fontsize=16,
        fontweight="bold",
    )
    fig.text(
        0.05,
        0.07,
        "Left: batch 4096, median across 0/50/100% hits and 3 seeds; equal bitmap bytes, different FPR.",
        fontsize=10,
        color="#444444",
    )
    fig.text(
        0.05,
        0.03,
        "Right: 32 actual bits/key, 50% hits, 3 seeds; thread startup included. Prehashed inputs throughout.",
        fontsize=10,
        color="#444444",
    )
    fig.subplots_adjust(left=0.09, right=0.98, top=0.81, bottom=0.24, wspace=0.32)
    out = ROOT / "docs" / "figures"
    out.mkdir(exist_ok=True)
    fig.savefig(
        out / "throughput.svg",
        metadata={"Date": None, "Creator": "scripts/plot_results.py"},
    )
    svg = out / "throughput.svg"
    svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
    fig.savefig(out / "throughput.png", dpi=160)
    print("Wrote docs/figures/throughput.svg and .png")


if __name__ == "__main__":
    main()
