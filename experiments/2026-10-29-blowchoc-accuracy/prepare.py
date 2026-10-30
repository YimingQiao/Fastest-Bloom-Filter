"""Create the prespecified accuracy protocol without importing/JITing Numba."""
import argparse
import hashlib
import json
import math
from pathlib import Path
import random

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
BRIDGE = ROOT / "benchmarks/blowchoc-external"
MASK = (1 << 64) - 1
NATIVE = ["FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter", "ByteSplitBloomFilter"]


def first_random(seed):
    value = (seed + 0x9e3779b97f4a7c15) & MASK
    value = ((value ^ (value >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & MASK
    return value ^ (value >> 31)


def names(rng, count, moduli):
    # Independent transcription of pinned populate_hashfunc_tuple's random
    # multiplier helper. Runtime factories still call unchanged upstream code;
    # equality with these prespecified strings is checked before any accuracy.
    while True:
        values = [rng.randrange(3, (1 << 32) - 1, 2) for _ in range(count)]
        if len(set(values)) == count and all(math.gcd(value, modulus) == 1
                                             for value, modulus in zip(values, moduli)):
            return [f"linear{value}" for value in values]


def construction(blocks, choices, probes, version):
    rng = random.Random(113)
    sub = names(rng, 1, [1])
    bucket = names(rng, choices, [blocks] * choices)
    moduli = [512] * probes if version == "random" else list(range(512, 512 - probes, -1))
    bits = names(rng, probes, moduli)
    return dict(universe=4**32, nsubfilters=1, nblocks=blocks,
                nblocks_per_subfilter=blocks, nchoices=choices, nbits=probes,
                bitversion=version, beta=(1 + math.sqrt(5)) / 2, mu=1.0,
                subfilter_hashfuncs_str=sub, bucket_hashfuncs_str=bucket,
                bit_hashfuncs_str=bits, construction_seed=113)


def prepare(bridge_commit):
    freeze = json.loads((BRIDGE / "FREEZE.json").read_text())
    evidence = json.loads((BRIDGE / "validation/accuracy.json").read_text())["metadata"]
    compiler = json.loads((BRIDGE / "validation/environment.json").read_text())
    configs = [{"filter": name, "family": "native"} for name in NATIVE]
    for choices in (1, 2):
        for probes in (8, 14):
            for version in ("random", "distinct"):
                configs.append(dict(filter=f"BlowChocC{choices}K{probes}{version.title()}",
                                    family="blowchoc", choices=choices, probes=probes, version=version))
    cases = []
    for key_power in (16, 20):
        for requested_bpk in (8, 16):
            n, q = 1 << key_power, 1 << 20
            budget = n * requested_bpk // 4  # strict next power2 = twice requested bytes
            blocks = (budget - 448) // 64
            if blocks % 2 == 0:
                blocks -= 1
            assert blocks * 64 + 448 == budget
            base = first_random(42) % ((1 << 32) - n - q)
            case = dict(id=f"n{key_power}-requested{requested_bpk}", key_power=key_power,
                        keys=n, queries=q, requested_bpk=requested_bpk, actual_bpk=8 * budget // n,
                        payload_bytes=budget, seed=42, construction_seed=113, key_base=base,
                        inserted_raw_interval=[base, base + n],
                        query_negative_raw_bounds=[base + n, base + n + q],
                        calibration_raw_interval=[base + n + q, base + n + q + (1 << 24)],
                        constructions={})
            for config in configs:
                if config["family"] == "blowchoc":
                    case["constructions"][config["filter"]] = construction(
                        blocks, config["choices"], config["probes"], config["version"])
            cases.append(case)
    protocol = dict(stage="prespecified accuracy-only; no throughput ranking", date="2026-10-29",
                    bridge_commit=bridge_commit, bridge_freeze_sha256=hashlib.sha256((BRIDGE / "FREEZE.json").read_bytes()).hexdigest(),
                    upstream_commit=freeze["upstream_commit"], native_source_commit=freeze["native_source_commit"],
                    native_library="build/blowchoc-bridge/libblowchoc_native.so",
                    native_library_sha256=freeze["binaries"]["build/blowchoc-bridge/libblowchoc_native.so"]["sha256"],
                    configs=configs, cases=cases, expected_rows=48, query_power=20, hit_percent=50,
                    batch=4096, calibration_power=24, calibration_probes_per_configuration=1 << 24,
                    cpu=3, socket=1, lock="/tmp/fastest-bf-socket1.lock", measure=False,
                    build_modes=["prehashed", "common-fused", "common-staged"],
                    query_modes=["prehashed", "common-fused", "common-staged"],
                    construction_policy="All choices/probes/bit strategies/hash strings fixed before seeing results; no hash-seed selection by FPR.",
                    statistics="Per-configuration Wilson two-sided95% upper only; no pooling across configurations, allocations, key counts, or repeated input/calibration streams.",
                    future_heldout="New input AND construction seeds, excluding construction113; prespecified before any performance selection.",
                    preflight="Every parameter set, including K14, exact independent complete bitmap/output oracle and earlier-factory rebuild after later factories overwrite globals; finish all preflights in each case before recording accuracy.",
                    allocation="Actual owning NumPy allocation including448B slack; positions scratch2*K separately; hash scratch8*batch shared. Native payload under same cap.",
                    compiler=compiler["compiler"], native_flags=compiler["native_flags"],
                    expected_runtime={key: evidence[key] for key in ("python", "numpy", "numba", "llvmlite", "jit_host_cpu", "jit_host_features", "llvm_version", "numba_cpu_name", "numba_cpu_features")})
    (HERE / "protocol.json").write_text(json.dumps(protocol, indent=2) + "\n")
    return protocol


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bridge-commit", default=None)
    args = parser.parse_args()
    result = prepare(args.bridge_commit)
    print(f"Prespecified {len(result['cases'])} cases/{result['expected_rows']} rows and 32 construction hash sets; no JIT or accuracy run.")
