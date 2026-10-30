#!/usr/bin/env python3
"""Source-only snapshot/bridge derivation; never builds or invokes a filter."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PLAN = "61f068907665fef2cb8ceafcc9c2f014f96b281e"
PLAN_PATH = "experiments/2026-10-29-k12-singleton-external-plan/"


def blob(commit, path):
    return subprocess.check_output(["git", "show", commit + ":" + path], cwd=ROOT)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    pins = json.loads(blob(PLAN, PLAN_PATH + "sources.json"))
    selection = json.loads(blob(PLAN, PLAN_PATH + "selection.json"))
    outputs, consumed = {}, {}

    def source(key):
        ref = pins[key]
        raw = blob(ref["commit"], ref["path"])
        assert hashlib.sha256(raw).hexdigest() == ref["sha256"]
        consumed[key] = ref
        return raw

    for filename in ("base.h", "layout_detail.h", "fast_pattern_BF.h", "four_sector_bloom.h",
                     "split64_bloom.h", "byte_split_bloom.h", "split64_range_bloom.h", "split64_range_size.h"):
        outputs[filename] = source("native_" + filename)
    for key, filename in (("candidate", "candidate.h"), ("old_k12", "control.h"),
                          ("budget", "budget.hpp"), ("cpp_adapters", "cpp-adapters.hpp"),
                          ("rocks_adapters", "rocks-adapters.hpp")):
        outputs[filename] = source(key)
    # This is the identical facade already proved by the visible60 caller.
    boost = source("boost_adapters").decode()
    facade = source("boost_visible_shim").decode()
    begin = facade.index("\t// Direct unchanged upstream one-key API")
    end = facade.index("\tuint32_t Lookup", begin)
    shim = facade[begin:end]
    marker = "\tuint32_t Lookup(uint32_t n, const uint64_t *keys, uint32_t *out) const {"
    assert boost.count(marker) == 1 and "ScalarContains" not in boost
    outputs["boost-adapters.hpp"] = boost.replace(marker, shim + marker).encode()
    outputs["BOOST_VISIBLE.patch"] = "".join(difflib.unified_diff(boost.splitlines(True),
        outputs["boost-adapters.hpp"].decode().splitlines(True), fromfile="frozen-exact-boost", tofile="same-constructor-with-proved-public-facade")).encode()
    outputs["adapters.hpp"] = b'''#pragma once
#include "fast_pattern_BF.h"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
#include "split64_range_bloom.h"
#include "control.h"
#include "candidate.h"
#include "cpp-adapters.hpp"
#include "boost-adapters.hpp"
#include "rocks-adapters.hpp"
using K12Control = FourSectorRange12BloomFilter;
using K12SingletonVector = FourSectorRange12SingletonVectorExperiment;
using Split64Range = Split64RangeBloomFilter;
'''
    geometry = source("exact_geometry").decode()
    old = '''template<> struct Traits<ByteSplitRangeExperiment> : RangeTraits<ByteSplitRangeExperiment, 16, -1> {};
template<> struct Traits<Split64RangeExperiment> : RangeTraits<Split64RangeExperiment, 64, 8> {};'''
    new = '''template<class BF, int K> struct NativeRangeTraits : RangeTraits<BF, 64, K> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        auto g = RangeTraits<BF, 64, K>::Plan(n, bpk);
        // Public BF(real_n,bpk) constructor argument, not the derived byte budget.
        g.constructor_argument = bpk;
        g.kind = "native_range_lines";
        return g;
    }
};
template<> struct Traits<Split64Range> : NativeRangeTraits<Split64Range, 8> {};
template<> struct Traits<K12Control> : NativeRangeTraits<K12Control, 12> {};
template<> struct Traits<K12SingletonVector> : NativeRangeTraits<K12SingletonVector, 12> {};'''
    assert geometry.count(old) == 1
    outputs["geometry.hpp"] = geometry.replace(old, new).encode()
    outputs["GEOMETRY.patch"] = "".join(difflib.unified_diff(geometry.splitlines(True),
        outputs["geometry.hpp"].decode().splitlines(True), fromfile="frozen-exact-geometry", tofile="same-exact-recipes-native-range-types")).encode()
    query = source("actual_query_helpers").decode()
    old_query = '''template <class BF, class Hash>
__attribute__((always_inline)) inline uint32_t visible_single(const BF &bf, Hash hash) {
    return static_cast<uint32_t>(bf.ContainsHash(hash));
}'''
    new_query = '''template <class BF, class Hash, class = void> struct HasContainsHash : std::false_type {};
template <class BF, class Hash> struct HasContainsHash<BF, Hash,
    std::void_t<decltype(std::declval<const BF&>().ContainsHash(std::declval<Hash>()))>> : std::true_type {};
template <class BF, class Hash, class = void> struct HasScalarContains : std::false_type {};
template <class BF, class Hash> struct HasScalarContains<BF, Hash,
    std::void_t<decltype(std::declval<const BF&>().ScalarContains(std::declval<Hash>()))>> : std::true_type {};
template <class BF, class Hash>
__attribute__((always_inline)) inline uint32_t visible_single(const BF &bf, Hash hash) {
    if constexpr (HasContainsHash<BF, Hash>::value) return static_cast<uint32_t>(bf.ContainsHash(hash));
    else if constexpr (HasScalarContains<BF, Hash>::value) return static_cast<uint32_t>(bf.ScalarContains(hash));
    else { uint32_t answer; bf.Lookup(1, &hash, &answer); return answer; }
}'''
    assert query.count(old_query) == 1
    outputs["query_helpers.hpp"] = query.replace("#include <type_traits>", "#include <type_traits>\n#include <utility>").replace(old_query, new_query).encode()
    outputs["PUBLIC_API.patch"] = "".join(difflib.unified_diff(query.splitlines(True),
        outputs["query_helpers.hpp"].decode().splitlines(True), fromfile="proved-actual-query-helper", tofile="same-helper-with-public-api-traits")).encode()
    rows = []
    for point in selection["points"]:
        g = point["geometry"]
        type_name = "bloom_filters::FastPatternBF" if g["filter"] == "FastPatternBF" else g["filter"]
        rows.append('ADD(%s, "%s", "%s", "%s", %s, %s, %s, %s, %s, %s, %s, %s, "%s", "%s", %s)' % (
            type_name, g["filter"], point["id"], point["owner"], int(g["keys"]), int(g["requested_bpk"]),
            int(g["filter_bytes"]), int(g["logical_bytes"]), int(g["unit_bytes"]), int(g["unit_count"]),
            int(g["effective_probes"]), int(g["constructor_argument"]), g["geometry_kind"], g["probe_policy"], int(g.get("native_constructor_bpk",0))))
    outputs["points.inc"] = ("// Exact64 frozen API/geometry points; only outside-timer construction metadata.\n" + "\n".join(rows) + "\n").encode()
    parent_main = source("actual_caller").decode()
    utility = parent_main[parent_main.index("using namespace bloom_filters;"):parent_main.index("struct Case {")]
    input_struct = parent_main[parent_main.index("struct Input {"):parent_main.index("struct Output {")]
    output_struct = parent_main[parent_main.index("struct Output {"):parent_main.index("template <class BF> void Run(")]
    timed = parent_main[parent_main.index("    const unsigned four[4][4]"):parent_main.index("    if (Digest(d.inserted_raw.data(),n)")]
    template = (HERE / "main.in.cpp").read_text()
    for name, value in (("UTILITY", utility), ("INPUT", input_struct), ("OUTPUT", output_struct), ("TIMED_QUERY", timed)):
        marker = "@" + name + "@"
        assert template.count(marker) == 1
        template = template.replace(marker, value)
    outputs["main.cpp"] = template.encode()
    outputs["MAIN.patch"] = "".join(difflib.unified_diff(parent_main.splitlines(True), template.splitlines(True),
        fromfile="proved-two-native-caller", tofile="same-clocks-complete-public-panel")).encode()
    assert template.count(timed) == 1
    dependency_commit = pins["exact_geometry"]["commit"]
    dependency_path = "experiments/2026-10-29-exact-budget-range/freeze.json"
    dependency_raw = blob(dependency_commit, dependency_path)
    dependency_freeze = json.loads(dependency_raw)
    prefixes = ("benchmarks/boost-external/.deps/boost_1_92_0/",
                "benchmarks/rocksdb-external/vendor/",
                "build/all-external-confirmation/_deps/fastfilter-src/",
                "build/all-external-confirmation/_deps/pagebloom-src/")
    external = {path: sha for path, sha in dependency_freeze["source_sha256"].items() if path.startswith(prefixes)}
    assert external and all(any(path.startswith(prefix) for path in external) for prefix in prefixes)
    for path, sha in external.items():
        assert hashlib.sha256((ROOT/path).read_bytes()).hexdigest() == sha, path
    outputs["upstream-pins.json"] = (json.dumps({"descriptor_commit": dependency_commit,
        "descriptor_path": dependency_path, "descriptor_sha256": hashlib.sha256(dependency_raw).hexdigest(),
        "source_sha256": external,
        "scope": "exact previously consumed FastFilter/Page/Boost1.92/Rocks headers; unknown repository dependencies must fail before executable tests"},
        indent=2, sort_keys=True) + "\n").encode()
    proof_commit = "c2cd9f7a8237cd37e13270a6071eebd02de61f13"
    old_stage = "experiments/2026-10-29-k12-singleton-vector-plan/caller/"
    old_commands_raw = blob(proof_commit, old_stage + "validation-v1/commands.json")
    old_commands = json.loads(old_commands_raw)
    references = {}
    fields = ("keys", "queries", "actual_bytes", "hit", "batch", "repeats", "seed", "key_base",
              "inserted_digest", "query_digest", "inserted_hash_digest", "query_hash_digest", "result_digest",
              "present", "absent", "false_positives")
    for profile in ("normal", "minimal-f", "asan"):
        command = next(c for c in old_commands if c["label"] == profile + "-caller-4")
        path = old_stage + command["stdout"]
        raw = blob(proof_commit, path)
        assert hashlib.sha256(raw).hexdigest() == command["stdout_sha256"]
        old_rows = [json.loads(line) for line in raw.splitlines()]
        references[profile] = {"commit": proof_commit, "path": path, "sha256": hashlib.sha256(raw).hexdigest(),
                               "expected": [{"old_filter": r["filter"], **{k: r[k] for k in fields}} for r in old_rows]}
    outputs["old-reference.json"] = (json.dumps({"scope": "old seen74381 correctness only; no historical latency retained",
        "command_commit": proof_commit, "command_path": old_stage+"validation-v1/commands.json",
        "command_sha256": hashlib.sha256(old_commands_raw).hexdigest(), "profiles": references}, indent=2, sort_keys=True)+"\n").encode()
    outputs["lease.py"] = blob(pins["actual_caller"]["commit"], old_stage + "lease.py")
    outputs["DERIVATION.json"] = (json.dumps({"plan_commit": PLAN, "sources": consumed,
        "scope": "byte-identical native kernels/external hot methods; one proved Boost facade, public API selection traits and native geometry registrations only",
        "files": {name: hashlib.sha256(value).hexdigest() for name, value in outputs.items()}}, indent=2, sort_keys=True) + "\n").encode()
    for name, content in outputs.items():
        path = HERE / name
        if args.write:
            path.write_bytes(content)
        elif path.read_bytes() != content:
            raise ValueError("source derivative differs: " + name)
    print("verified", len(outputs), "source artifacts; no compiler/BF")


if __name__ == "__main__":
    main()
