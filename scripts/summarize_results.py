#!/usr/bin/env python3
"""Rebuild the measured report from committed raw CSV data (standard library only)."""
import csv
import json
from pathlib import Path
from statistics import median

ROOT = Path(__file__).resolve().parents[1]
DAY = "2026-10-28"
HISTORICAL_SERIES = (
    "cpp",
    "rust",
    "parallel-cpp",
    "parallel-rust",
    "small-batches-cpp",
    "small-batches-rust",
    "avx2-cpp",
    "avx2-rust",
    "external",
    "before-alignment-cpp",
    "before-alignment-rust",
    "before-avx2-cpp",
)


def rows(name):
    with (ROOT / "results" / f"{DAY}-{name}" / "results.csv").open() as f:
        return list(csv.DictReader(f))


def value(row, key):
    return float(row[key])


def key(row):
    return tuple(
        row[k] for k in ("keys", "requested_bpk", "hit_percent", "batch", "seed")
    )


def ratio(native, reference, metric):
    return median(
        min(
            value(b, metric)
            for b in reference[key(r)]
            if b["filter_bytes"] == r["filter_bytes"]
        )
        / value(r, metric)
        for r in native
    )


def table(headers, data):
    return "\n".join(
        [
            "| " + " | ".join(headers) + " |",
            "| " + " | ".join(["---"] * len(headers)) + " |",
        ]
        + ["| " + " | ".join(map(str, row)) + " |" for row in data]
    )


def speed(x):
    return f"{x:.2f}×"


def main():
    checks = {}
    total = 0
    # This report describes a frozen campaign. Later modern layouts have
    # different bitmaps and must not enter its historical parity/count totals.
    for name in HISTORICAL_SERIES:
        path = ROOT / "results" / f"{DAY}-{name}" / "results.csv"
        data = list(csv.DictReader(path.open()))
        metadata = json.loads((path.parent / "metadata.json").read_text())
        assert metadata["runs"] and all(r["returncode"] == 0 for r in metadata["runs"])
        total += len(data)
        for row in data:
            if not row["filter"].startswith("FastPattern"):
                continue
            kind = "parallel" if "threads" in row else "single"
            identity = (kind,) + tuple(
                row[f]
                for f in ["keys", "queries", "requested_bpk", "hit_percent", "seed"]
            )
            answer = tuple(
                row[f]
                for f in [
                    "filter_bytes",
                    "absent_queries",
                    "false_positives",
                    "result_checksum",
                ]
            )
            assert checks.setdefault(identity, answer) == answer, (path, identity)
    print(
        f"Validated {total} rows; {len(checks)} unique workloads agree across backends and versions."
    )
    cpp, rust = rows("cpp"), rows("rust")
    refs = {}
    for r in cpp:
        if r["filter"] in ("CacheSectorizedBF32Bit", "NewCacheSectorizedBF32Bit"):
            refs.setdefault(key(r), []).append(r)
    native = {
        lang: [r for r in data if r["filter"] == "FastPatternBF"]
        for lang, data in [("C++", cpp), ("Rust", rust)]
    }
    # Every configuration has the same full output across independent native implementations.
    checks = {key(r): r["result_checksum"] for r in native["C++"]}
    assert len(checks) == len(native["Rust"]) == 135
    assert all(checks[key(r)] == r["result_checksum"] for r in native["Rust"])
    text = [
        f"# Measured results — {DAY}",
        """
Intel Xeon Platinum 8474C (Sapphire Rapids), one NUMA socket, Linux; Clang 23 and
Rust 1.92, native CPU instructions including AVX-512. Each socket has 97.5 MiB L3;
each core has 2 MiB L2. Single-thread runs use CPU 2. Scaling runs restrict the
process to the first T physical cores from CPUs 2,4,...,64 on the same socket.
These are measurements on one shared machine, without exclusive system reservation,
fixed-frequency control, or NUMA memory binding. Allocation/first-touch and OS
scheduling may affect results. No cross-machine or universal fastest claim is made.

All query timings below use precomputed hashes unless labeled hash+query.
The single-thread matrix has 135 cases per language: five sizes, three space
budgets, three hit rates, and three seeds. Each case has 2^22 queries, batch 4096,
five timed repetitions; each CSV row is a median. The tables then take the median
of per-case speed ratios over hit rates 0/50/100% and seeds 42/43/44 (nine cases).
These are throughput measurements; a fractional ns/key is not single-query latency.

## Single-thread speed and space

Reference: the faster of the repository's **original two cache-sectorized C++
implementations**, selected separately for each metric and workload, restricted to
exactly the same allocated payload bytes as FastPattern. Rust is compared to that
same C++ reference. This is not a ranking against every Bloom design at equal FPR.
Ratios above 1 favor FastPattern; below 1 are regressions. The capped 64 MiB legacy
implementation is excluded where the new filter allocates 128 MiB.
""",
    ]
    for bpk in [4, 8, 16]:
        data = []
        for power in [12, 16, 20, 24, 25]:
            selected = {
                lang: [
                    r
                    for r in rs
                    if int(r["keys"]) == 2 ** power and int(r["requested_bpk"]) == bpk
                ]
                for lang, rs in native.items()
            }
            payload = int(selected["C++"][0]["filter_bytes"])
            size = (
                f"{payload / 2**20:g} MiB"
                if payload >= 2**20
                else f"{payload / 1024:g} KiB"
            )
            result = [f"2^{power}", size]
            for metric in ["lookup_ns", "hash_lookup_ns", "insert_ns"]:
                result += [
                    speed(ratio(selected[lang], refs, metric))
                    for lang in ["C++", "Rust"]
                ]
            data.append(result)
        text += [
            f"### {2*bpk} actual bits/key ({bpk} requested)",
            table(
                [
                    "Keys",
                    "Payload",
                    "C++ query",
                    "Rust query",
                    "C++ hash+query",
                    "Rust hash+query",
                    "C++ insert",
                    "Rust insert",
                ],
                data,
            ),
        ]
    data = []
    for bpk in [4, 8, 16]:
        line = [str(2 * bpk)]
        for f in ["FastPatternBF", "CacheSectorizedBF32Bit"]:
            rr = [
                r
                for r in cpp
                if r["filter"] == f
                and r["hit_percent"] == "0"
                and int(r["requested_bpk"]) == bpk
            ]
            fp = sum(int(r["false_positives"]) for r in rr)
            absent = sum(int(r["absent_queries"]) for r in rr)
            line.append(f"{100*fp/absent:.4f}% ({fp:,}/{absent:,})")
        data.append(line)
    text += [
        """### Observed false-positive rate

Pooled all-miss queries across five sizes and three seeds; the full per-case counts
remain in CSV. These observations are not a proof or target-FPR guarantee.""",
        table(["Actual bits/key", "FastPattern", "Original cache-sectorized"], data),
        """The 32-bit register filters can be faster for small, resident bitmaps, with
higher FPR. At large sizes their 512 KiB allocation cap leads to saturation;
those rows remain visible in raw data and are not comparable in space or accuracy.
The Impala-style designs can deliver lower FPR than FastPattern at some budgets.
Small-filter insertion is a real regression for FastPattern. Including hashing
reduces the query speedup. Users should choose on the speed/space/FPR frontier.""",
    ]
    parallel = {
        lang: rows("parallel-" + lang.lower().replace("c++", "cpp"))
        for lang in ["C++", "Rust"]
    }
    # Compare all three build modes across both languages for every scaling workload.
    parity = {}
    for lang, data in parallel.items():
        assert len(data) == 162, (lang, len(data))
        for r in data:
            k = tuple(
                r[f]
                for f in ["keys", "threads", "seed", "requested_bpk", "hit_percent"]
            )
            parity.setdefault(k, set()).add(r["result_checksum"])
    assert len(parity) == 54 and all(len(v) == 1 for v in parity.values())
    text += [
        """## Multithreaded scaling

32 actual bits/key, 50% hits, 2^22 queries per case; three timed repetitions and
seeds 42/43/44. Each speedup is the median of same-process, same-seed serial-time /
partitioned-time ratios. Thread creation/join, histogram, partition scatter, and
scratch allocation are included. Filter allocation is excluded for all modes.
Each row compares against the native serial implementation in the same language.
The API launches threads per call; it is not a persistent-pool benchmark.
"""
    ]
    for power in [20, 24, 25]:
        data = []
        for threads in [1, 2, 4, 8, 16, 32]:
            line = [str(threads)]
            for lang in ["C++", "Rust"]:
                rr = [
                    r
                    for r in parallel[lang]
                    if int(r["keys"]) == 2 ** power and int(r["threads"]) == threads
                ]
                serial = {
                    r["seed"]: r for r in rr if r["filter"] == "FastPatternSerial"
                }
                part = [r for r in rr if r["filter"] == "FastPatternPartitioned"]
                for metric in ["insert_ns", "lookup_ns"]:
                    line.append(
                        speed(
                            median(
                                value(serial[r["seed"]], metric) / value(r, metric)
                                for r in part
                            )
                        )
                    )
            data.append(line)
        text += [
            f"### 2^{power} keys, {2**(power-18)} MiB payload",
            table(
                ["Threads", "C++ build", "C++ query", "Rust build", "Rust query"], data
            ),
        ]
    text += [
        """### Concurrent atomic API cost

Absolute ns/key at 8 workers, 2^24 keys, 64 MiB bitmap, 50% hits; median across seeds.
Atomic rows measure build then read-only query throughput, not an overlapping
reader/writer throughput test. Separate correctness tests exercise overlapping
readers and writers. The atomic type cannot use ordinary non-atomic SIMD bitmap
reads while writers are active."""
    ]
    data = []
    for lang in ["C++", "Rust"]:
        for mode in [
            "FastPatternSerial",
            "FastPatternPartitioned",
            "FastPatternAtomic",
        ]:
            rr = [
                r
                for r in parallel[lang]
                if int(r["keys"]) == 2**24
                and r["threads"] == "8"
                and r["filter"] == mode
            ]
            data.append(
                [
                    lang,
                    mode.removeprefix("FastPattern"),
                    f"{median(value(r, 'insert_ns') for r in rr):.3f}",
                    f"{median(value(r, 'lookup_ns') for r in rr):.3f}",
                    f"{int(rr[0]['build_scratch_bytes']):,}",
                ]
            )
    text += [
        table(
            [
                "Language",
                "Mode",
                "Build ns/key",
                "Query ns/key",
                "Explicit build scratch bytes",
            ],
            data,
        ),
        """Scratch reporting excludes allocator metadata, thread stacks, and input/output
buffers. Partitioned construction uses about eight temporary bytes per input hash
plus worker metadata. The atomic type has no partition buffer. Neither type
supports deletion or concurrent resizing. See the README for concurrency semantics.""",
    ]
    for name, title in [
        ("small-batches-cpp", "Small and irregular batches (C++)"),
        ("small-batches-rust", "Small and irregular batches (Rust)"),
        ("avx2-cpp", "AVX2 build (GCC C++)"),
        ("avx2-rust", "AVX2 build (Rust)"),
    ]:
        path = ROOT / "results" / f"{DAY}-{name}" / "results.csv"
        if not path.exists():
            continue
        data = rows(name)
        reference = {}
        for r in data:
            if r["filter"] in ("CacheSectorizedBF32Bit", "NewCacheSectorizedBF32Bit"):
                reference.setdefault(key(r), []).append(r)
        out = []
        for n in sorted({int(r["keys"]) for r in data}):
            for batch in sorted({int(r["batch"]) for r in data}):
                rr = [
                    r
                    for r in data
                    if r["filter"] == "FastPatternBF"
                    and int(r["keys"]) == n
                    and int(r["batch"]) == batch
                ]
                out.append(
                    [
                        f"{n:,}",
                        str(batch),
                        speed(ratio(rr, reference, "lookup_ns")),
                        speed(ratio(rr, reference, "hash_lookup_ns")),
                    ]
                )
        text += [
            f"## {title}",
            "16 actual bits/key; ratios to the faster original sectorized implementation in the same run and language. "
            "Median across the recorded seeds and hit rates. AVX2 rows use dedicated vector kernels; "
            "their build flags differ from the native AVX-512 runs.",
            table(["Keys", "Batch", "Query speedup", "Hash+query speedup"], out),
        ]
    before_path = ROOT / "results" / f"{DAY}-before-avx2-cpp" / "results.csv"
    if before_path.exists():
        before = {
            key(r): r for r in rows("before-avx2-cpp") if r["filter"] == "FastPatternBF"
        }
        after = [r for r in rows("avx2-cpp") if r["filter"] == "FastPatternBF"]
        out = []
        for n in sorted({int(r["keys"]) for r in after}):
            rr = [r for r in after if int(r["keys"]) == n]
            out.append(
                [f"{n:,}"]
                + [
                    speed(median(value(before[key(r)], m) / value(r, m) for r in rr))
                    for m in ["insert_ns", "lookup_ns"]
                ]
            )
        text += [
            "### AVX2 kernels versus the previous scalar fallback",
            "Same GCC AVX2 flags and workload; median ratios across nine cases per size. "
            "The earlier run is retained under `before-avx2-cpp`.",
            table(["Keys", "Build improvement", "Query improvement"], out),
        ]
    out = []
    for lang, suffix in [("C++", "cpp"), ("Rust", "rust")]:
        before = [
            r
            for r in rows("before-alignment-" + suffix)
            if r["filter"] == "FastPatternPartitioned"
            and r["keys"] == str(2**24)
            and r["threads"] == "8"
        ]
        after = [
            r
            for r in parallel[lang]
            if r["filter"] == "FastPatternPartitioned"
            and r["keys"] == str(2**24)
            and r["threads"] == "8"
        ]
        out.append(
            [
                lang,
                f"{median(value(r, 'insert_ns') for r in before):.3f}",
                f"{median(value(r, 'insert_ns') for r in after):.3f}",
            ]
        )
    text += [
        "## Cache-line alignment experiment",
        "64 MiB bitmap, eight workers, 50% hits. Median build ns/key across seeds. "
        "Padding histogram row strides alone left possible boundary false sharing. "
        "Aligning the allocation as well improved the measured build cost. The initial full "
        "scaling matrices remain under `before-alignment-*`; their metadata preserves the "
        "original output-directory command even though the archived directories were renamed.",
        table(["Language", "Padded rows only", "Padded and aligned rows"], out),
    ]

    path = ROOT / "results" / f"{DAY}-external" / "results.csv"
    if path.exists():
        data = rows("external")
        out = []
        for n in sorted({int(r["keys"]) for r in data}):
            for bpk in [4, 8, 16]:
                rr = [
                    r
                    for r in data
                    if int(r["keys"]) == n and int(r["requested_bpk"]) == bpk
                ]
                ext = {key(r): r for r in rr if r["filter"] == "Fastbloom017"}
                own = [r for r in rr if r["filter"] == "FastPatternBF"]
                line = [
                    f"{n:,}",
                    str(2 * bpk),
                    speed(
                        median(
                            value(ext[key(r)], "lookup_ns") / value(r, "lookup_ns")
                            for r in own
                        )
                    ),
                ]
                for f in ["FastPatternBF", "Fastbloom017"]:
                    neg = [
                        r for r in rr if r["filter"] == f and r["hit_percent"] == "0"
                    ]
                    fp = sum(int(r["false_positives"]) for r in neg)
                    q = sum(int(r["absent_queries"]) for r in neg)
                    line.append(f"{100*fp/q:.6f}% ({fp:,}/{q:,})")
                out.append(line)
        text += [
            """## External reference: fastbloom 0.17.0

Same Rust compiler, bitmap payload bytes, inputs, and prehashing. fastbloom chooses
its hash count using `expected_items`; this is **not an equal-FPR comparison**.
The ratio uses all three hit rates and seeds; FPR uses only all-miss queries.
Zero observed positives do not establish zero FPR. See the
[adapter contract](../benchmarks/rust-external/README.md) for API details.""",
            table(
                [
                    "Keys",
                    "Actual bits/key",
                    "FastPattern query speedup",
                    "FastPattern FPR",
                    "fastbloom FPR",
                ],
                out,
            ),
        ]
    text += [
        """## Validation and provenance

All 135 native single-thread cases have identical full-output checksums in C++ and
Rust. All 54 scaling configurations agree across both languages and all three
construction modes. The harness checks every inserted key before accepting timing
rows. Local Clang native and GCC AVX2 CTest suites, C++ ASan/UBSan, C++ ThreadSanitizer,
Rust tests, fmt and clippy, and cross-language parity checks passed. Rust ThreadSanitizer
was not run successfully: the installed standard library is not sanitizer-instrumented.

Raw CSV rows, individual case output, exact commands, CPU/compiler information,
binary hashes, source revision and tracked source patches are under [`results/`](../results/).
The original single-thread C++ run recorded local commit `0dc51d7`. Its published
equivalent is `fa8fe3d`: the only change is relocating the identical CI reference
YAML from `.github/workflows/ci.yml` to `scripts/ci-reference.yml`, because the GitHub
token cannot publish workflow files. No compiled source changed in that amendment.
The original recorded revision is preserved in metadata. Dedicated AVX2 kernels
were added later; their separate matrices record that revision. The original
AVX-512 query algorithm and bitmap layout are unchanged. Scaling measurements use
later revisions containing the parallel implementation; their metadata records each
exact revision. Untracked result directories are recorded but are not build inputs.

Rebuild this report with `python3 scripts/summarize_results.py`. The CI YAML is a
reference template, not an enabled GitHub workflow. Local validation is not remote CI.
"""
    ]
    (ROOT / "docs" / f"results-{DAY}.md").write_text(
        "\n\n".join(part.strip() for part in text) + "\n"
    )
    print(f"Wrote docs/results-{DAY}.md; native and parallel parity verified.")


if __name__ == "__main__":
    main()
