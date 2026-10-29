#!/usr/bin/env python3
"""Copy the committed proposal and exact historical public-query helpers."""
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PLAN = "42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5"
PARENT = "experiments/2026-10-29-k12-singleton-vector-plan/"
TIMER = "8c32ea8bd185104a06013d229063de45757ccbd9"
TIMER_PATH = "experiments/2026-10-29-inline-single-query/preflight-v2-unforced/experiment/"

def read(commit, path):
    return subprocess.check_output(["git", "show", f"{commit}:{path}"], cwd=ROOT)

def main():
    pins = {}
    for name in ("control.h", "candidate.h", "base.h", "split64_range_size.h",
                 "mapping_oracle.hpp", "LICENSE", "protocol.json", "ledger.json"):
        data = read(PLAN, PARENT + name)
        (HERE / name).write_bytes(data)
        pins[name] = {"commit": PLAN, "path": PARENT + name,
                      "sha256": hashlib.sha256(data).hexdigest()}
    benchmark = read(TIMER, TIMER_PATH + "benchmark.cpp").decode()
    start = benchmark.index("template <class BF, class Hash>\n__attribute__((noinline)) void lookup_kernel")
    end = benchmark.index('#include "inline_query.hpp"', start)
    lookup = benchmark[start:end]
    visible = read(TIMER, TIMER_PATH + "inline_query.hpp").decode()
    start = visible.index("template <class BF, class Hash>\n__attribute__((always_inline)) inline uint32_t visible_single")
    original = visible[start:]
    end = original.index("template <bool Raw, class BF, class Hash>")
    # The old loop/timer boundary is unchanged; choose this native type's real
    # public singleton method, with no adapter-private shortcut.
    adapted = """template <class BF, class Hash>
__attribute__((always_inline)) inline uint32_t visible_single(const BF &bf, Hash hash) {
    return static_cast<uint32_t>(bf.ContainsHash(hash));
}
""" + original[end:]
    preamble = """#pragma once
#include "base.h"
#include <type_traits>
template <class BF> struct InlineRawKeyApi : std::false_type {};
"""
    (HERE / "query_helpers.hpp").write_text(preamble + lookup + adapted)
    (HERE / "PUBLIC_API.patch").write_text("".join(difflib.unified_diff(
        original.splitlines(True), adapted.splitlines(True),
        fromfile="frozen-visible-helper", tofile="actual-K12-public-helper")))
    pins["query_helpers.hpp"] = {
        "commit": TIMER, "benchmark_path": TIMER_PATH + "benchmark.cpp",
        "visible_path": TIMER_PATH + "inline_query.hpp",
        "benchmark_sha256": hashlib.sha256(benchmark.encode()).hexdigest(),
        "visible_sha256": hashlib.sha256(visible.encode()).hexdigest(),
        "generic_helper_exact": True, "visible_loop_exact": True,
        "only_public_binding_change": "call native ContainsHash"}
    (HERE / "DERIVATION.json").write_text(json.dumps(pins, indent=2) + "\n")
    print("Copied committed proposal and derived exact query boundaries; no compilation.")

if __name__ == "__main__":
    main()
