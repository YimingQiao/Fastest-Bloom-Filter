"""Prespecify two fresh input/construction pairs without importing NumPy/Numba."""
import argparse
import hashlib
import json
import math
from pathlib import Path
import random

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
BRIDGE = ROOT / "benchmarks/blowchoc-external"
SCREEN = ROOT / "experiments/2026-10-29-blowchoc-accuracy"
MASK = (1 << 64) - 1
SEED_PAIRS = ((31991, 503), (97157, 1709))
NATIVE = ["FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter", "ByteSplitBloomFilter"]


def first_random(seed):
    value = (seed + 0x9e3779b97f4a7c15) & MASK
    value = ((value ^ (value >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & MASK
    return value ^ (value >> 31)


def names(rng, count, moduli):
    while True:
        values = [rng.randrange(3, (1 << 32) - 1, 2) for _ in range(count)]
        if len(set(values)) == count and all(math.gcd(value, modulus) == 1
                                             for value, modulus in zip(values, moduli)):
            return [f"linear{value}" for value in values]


def construction(blocks, choices, probes, version, construction_seed):
    # Independent transcript of unchanged upstream hash-parameter generation;
    # actual factories must match these strings before observing any FPR data.
    rng = random.Random(construction_seed)
    sub = names(rng, 1, [1])
    bucket = names(rng, choices, [blocks] * choices)
    moduli = [512] * probes if version == "random" else list(range(512, 512 - probes, -1))
    bits = names(rng, probes, moduli)
    return dict(universe=4**32, nsubfilters=1, nblocks=blocks,
                nblocks_per_subfilter=blocks, nchoices=choices, nbits=probes,
                bitversion=version, beta=(1 + math.sqrt(5)) / 2, mu=1.0,
                subfilter_hashfuncs_str=sub, bucket_hashfuncs_str=bucket,
                bit_hashfuncs_str=bits, construction_seed=construction_seed)


def disjoint(left, right):
    return left[1] <= right[0] or right[1] <= left[0]


def prepare(bridge_commit, screen_commit):
    freeze = json.loads((BRIDGE / "FREEZE.json").read_text())
    screen_protocol = json.loads((SCREEN / "protocol.json").read_text())
    evidence = json.loads((BRIDGE / "validation/accuracy.json").read_text())["metadata"]
    compiler = json.loads((BRIDGE / "validation/environment.json").read_text())
    configs = [{"filter": name, "family": "native", "construction_seed_used": False} for name in NATIVE]
    for choices in (1, 2):
        for probes in (8, 14):
            for version in ("random", "distinct"):
                configs.append(dict(filter=f"BlowChocC{choices}K{probes}{version.title()}", family="blowchoc",
                                    choices=choices, probes=probes, version=version, construction_seed_used=True))
    cases = []
    for input_seed, construction_seed in SEED_PAIRS:
        for key_power in (16, 20):
            for requested_bpk in (8, 16):
                n, q = 1 << key_power, 1 << 20
                budget = n * requested_bpk // 4
                blocks = (budget - 448) // 64
                if blocks % 2 == 0:
                    blocks -= 1
                assert blocks * 64 + 448 == budget
                base = first_random(input_seed) % ((1 << 32) - n - q)
                case = dict(id=f"n{key_power}-requested{requested_bpk}-input{input_seed}-construction{construction_seed}",
                            key_power=key_power, keys=n, queries=q, requested_bpk=requested_bpk,
                            actual_bpk=8 * budget // n, payload_bytes=budget, seed=input_seed,
                            construction_seed=construction_seed, key_base=base,
                            inserted_raw_interval=[base, base + n],
                            query_negative_raw_bounds=[base + n, base + n + q],
                            calibration_raw_interval=[base + n + q, base + n + q + (1 << 24)], constructions={})
                for config in configs:
                    if config["family"] == "blowchoc":
                        case["constructions"][config["filter"]] = construction(
                            blocks, config["choices"], config["probes"], config["version"], construction_seed)
                cases.append(case)
    streams = {(case["seed"], case["key_power"]): case for case in cases}
    unique = list(streams.values())
    for i, case in enumerate(unique):
        calibration = case["calibration_raw_interval"]
        for other in unique:
            assert disjoint(calibration, other["inserted_raw_interval"])
            assert disjoint(calibration, other["query_negative_raw_bounds"])
        for other in unique[i + 1:]:
            assert disjoint(calibration, other["calibration_raw_interval"])
        for other in screen_protocol["cases"]:
            for field in ("inserted_raw_interval", "query_negative_raw_bounds", "calibration_raw_interval"):
                assert disjoint(calibration, other[field])
    protocol = dict(stage="prespecified held-out accuracy-only; no throughput ranking", date="2026-10-29",
                    bridge_commit=bridge_commit, screen_commit=screen_commit,
                    bridge_freeze_sha256=hashlib.sha256((BRIDGE / "FREEZE.json").read_bytes()).hexdigest(),
                    screen_freeze_sha256=hashlib.sha256((SCREEN / "FREEZE.json").read_bytes()).hexdigest(),
                    upstream_commit=freeze["upstream_commit"], native_source_commit=freeze["native_source_commit"],
                    native_library="build/blowchoc-bridge/libblowchoc_native.so",
                    native_library_sha256=freeze["binaries"]["build/blowchoc-bridge/libblowchoc_native.so"]["sha256"],
                    configs=configs, cases=cases, expected_rows=96, seed_pairs=[list(pair) for pair in SEED_PAIRS],
                    query_power=20, hit_percent=50, batch=4096, calibration_power=24,
                    calibration_probes_per_configuration=1 << 24, cpu=3, socket=1,
                    lock="/tmp/fastest-bf-socket1.lock", measure=False,
                    build_modes=["prehashed", "common-fused", "common-staged"],
                    query_modes=["prehashed", "common-fused", "common-staged"],
                    construction_policy="Retain all12 configs; all64 upstream hash sets fixed before data; no hash-seed selection by FPR. Native4 do not use construction seeds.",
                    statistics="Report per-case Wilson two-sided95% upper and worst case; never pool different construction hash functions into one fixed-filter confidence bound. No pooling of repeated calibration streams across allocations/configs.",
                    stream_audit="Four unique input-seed/size negative streams are pairwise disjoint, disjoint from all held-out inserted/query ranges, and disjoint from seed42 screening inserted/query/calibration ranges. Each repeats across requested8/16 without extra sample credit.",
                    preflight="Every actual-size/hash parameter set gets complete independent bitmap/output oracle; rebuild and requery earlier factories after later factory hash-global overwrites, before accuracy in each case.",
                    allocation="Charge full owning NumPy allocation including448B slack; positions2*K and shared hash scratch8*batch separately. Native payload under identical cap.",
                    compiler=compiler["compiler"], native_flags=compiler["native_flags"],
                    expected_runtime={key: evidence[key] for key in ("python", "numpy", "numba", "llvmlite", "jit_host_cpu", "jit_host_features", "llvm_version", "numba_cpu_name", "numba_cpu_features")})
    (HERE / "protocol.json").write_text(json.dumps(protocol, indent=2) + "\n")
    return protocol


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bridge-commit", default="0fdc290bbcb8f239226764ce2eaf09906551eada")
    parser.add_argument("--screen-commit", default=None)
    args = parser.parse_args()
    result = prepare(args.bridge_commit, args.screen_commit)
    print(f"Prespecified8 cases/{result['expected_rows']} rows,64 construction hash sets and4 disjoint negative streams; no JIT/data run.")
