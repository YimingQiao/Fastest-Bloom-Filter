#!/usr/bin/env python3
"""Derive public Poppy constructor geometry without constructing a Bloom filter."""
import argparse
import csv
import io
import json
import math
from pathlib import Path
import struct
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
UPSTREAM = ROOT / "build/poppy-source"
PIN = "992a13e27e8b09b2a832333a4ba3d160545fa866"
PLAN_COMMIT = "d3f15378fc0e18522e16c2b62b013e73f6b3bc9d"
PLAN = ROOT / "experiments/2026-10-29-poppy-public-constructor-plan"
POLICIES = ("none", "space", "speed", "best")
LN2 = math.log(2.0)
BUCKET_BITS = 32768


def need(ok, message):
    if not ok:
        raise ValueError(message)


def ceil_div(n, d):
    return (n + d - 1) // d


def next_power(n):
    return 1 << (n - 1).bit_length()


def bits(value):
    return struct.pack(">d", value).hex()


def predict(n, fpp, policy):
    """Translate the pinned make()/k()/cap_from_bit_size(), not a private API."""
    need(n > 0 and 0 < fpp < 1 and policy in POLICIES, "Unsupported planner input")
    capacity = int(abs(BUCKET_BITS * math.pow(LN2, 2.0) / math.log(fpp)))
    need(capacity > 0, "Public argument gives zero per-bucket capacity")
    buckets = math.ceil(n / capacity)
    k = math.ceil(LN2 * BUCKET_BITS / capacity)
    cache_bits = 0
    # Rust f64::round rounds positive halves away from zero; Python round does not.
    bits_per_entry = math.floor(BUCKET_BITS / capacity + 0.5)
    if policy in ("speed", "best"):
        cache_bits = next_power(n)
        cache_k = math.ceil(LN2 * cache_bits / n)
        cache_p = math.pow(1.0 - math.exp(-cache_k * n / cache_bits), cache_k)
        k = math.ceil(LN2 * cache_p * bits_per_entry)
        if policy == "speed":
            buckets = next_power(buckets)
    cache_bytes = ceil_div(cache_bits, 8)
    return dict(per_bucket_capacity=capacity, buckets=buckets, probes=k,
                cache_bits=cache_bits, cache_bytes=cache_bytes,
                backing_bytes=buckets * 4096 + cache_bytes,
                fpp_bits=bits(fpp), fpp_decimal=repr(fpp))


def interval(n, cap_bpk, policy):
    budget = n * cap_bpk // 8
    cache = ceil_div(next_power(n), 8) if policy in ("speed", "best") else 0
    available = (budget - cache) // 4096
    if available < 1:
        return dict(status="unsupported", reason="no complete bucket fits",
                    budget_bytes=budget, cache_bytes=cache)
    if policy == "speed":
        available = 1 << (available.bit_length() - 1)
    low = ceil_div(n, available)
    buckets = ceil_div(n, low)
    if policy == "speed":
        buckets = next_power(buckets)
    need(buckets > 1, "One-bucket geometry is outside this frozen finite grid")
    high = ceil_div(2 * n, buckets) - 1 if policy == "speed" else (n - 1) // (buckets - 1)
    need(low <= high and buckets <= available, "Invalid largest-fitting interval")
    return dict(status="supported", budget_bytes=budget, cache_bytes=cache,
                fitting_bucket_limit=available, actual_buckets=buckets,
                first_capacity=low, last_capacity=high)


def source_check():
    need(subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=UPSTREAM).decode().strip() == PIN,
         "Wrong Poppy checkout")
    need(not subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=all"], cwd=UPSTREAM),
         "Changed Poppy checkout")
    for path in sorted(PLAN.iterdir()):
        if not path.is_file():
            continue
        original = subprocess.check_output(["git", "show", PLAN_COMMIT + ":" + str(path.relative_to(ROOT))], cwd=ROOT)
        need(original == path.read_bytes(), "Changed predeclared constructor plan")
    pins = json.loads((PLAN / "source-pins.json").read_text())
    for item in pins["files"]:
        digest = subprocess.check_output(["git", "hash-object", str(UPSTREAM / item["path"])]).decode().strip()
        need(digest == item["git_blob_sha"], "Changed upstream source blob")


def derive():
    rows, ledger, intervals = [], [], []
    # Controls are constructed once per actual Params, then admitted to any cap they fit.
    for power in (16, 25):
        n = 1 << power
        for policy in POLICIES:
            for fpp in (0.01, 0.001, 0.0001):
                rows.append(dict(kind="ordinary_fpp_control", power=power, n=n,
                                 policy=policy, requested_cap_bpk=None,
                                 **predict(n, fpp, policy)))
            for cap in (12, 16, 24, 32):
                window = interval(n, cap, policy)
                intervals.append(dict(power=power, n=n, policy=policy, cap_bpk=cap, **window))
                need(window["status"] == "supported", "Unexpected unsupported fixed grid point")
                seen = {}
                for c in range(window["first_capacity"], window["last_capacity"] + 1):
                    fpp = math.exp(-BUCKET_BITS * math.pow(LN2, 2.0) / (c + 0.5))
                    predicted = predict(n, fpp, policy)
                    need(predicted["per_bucket_capacity"] == c, "Float constructor capacity differs from c")
                    need(predicted["buckets"] == window["actual_buckets"] and
                         predicted["backing_bytes"] <= window["budget_bytes"], "Largest-fitting geometry drift")
                    key = (predicted["buckets"], predicted["cache_bytes"], predicted["probes"])
                    chosen = key not in seen
                    if chosen:
                        seen[key] = c
                        rows.append(dict(kind="largest_fitting_public_k", power=power, n=n,
                                         policy=policy, requested_cap_bpk=cap, **predicted))
                    ledger.append(dict(power=power, policy=policy, cap_bpk=cap, capacity=c,
                                       **predicted, selected=chosen, representative_capacity=seen[key]))
    for index, row in enumerate(rows):
        row["id"] = f"poppy-{index:03d}"
        row["admissible_caps"] = [cap for cap in (12, 16, 24, 32) if row["backing_bytes"] <= row["n"] * cap // 8]
        row["parameter_fingerprint"] = [row["n"], row["policy"], row["fpp_bits"]]
        row["mapping_alias_group"] = [row["n"], row["buckets"], row["cache_bytes"], row["probes"]]
    return dict(upstream_commit=PIN, previous_plan_commit=PLAN_COMMIT,
                public_path="Params::new(real_n,f64::from_bits(bits)).opt(policy).try_into_v2()",
                key_powers=[16, 25], caps_bpk=[12, 16, 24, 32], policies=list(POLICIES),
                controls=24, selected_rows=len(rows), candidate_capacities=len(ledger),
                intervals=intervals, rows=rows, filter_workloads_run=0,
                scope="all distinct public K at each policy's largest fitting allocation, plus three ordinary FPR controls; not all smaller allocations"), ledger


def rendered():
    selection, ledger = derive()
    output = io.StringIO(newline="")
    writer = csv.DictWriter(output, fieldnames=list(ledger[0]), lineterminator="\n")
    writer.writeheader()
    writer.writerows(ledger)
    # The public inspector takes exact f64 bits; decimal parsing never selects geometry.
    tsv = "id\tn\tpolicy\tfpp_bits\tcapacity\tbuckets\tcache_bytes\tprobes\tbacking_bytes\n"
    for row in selection["rows"]:
        tsv += "\t".join(str(row[key]) for key in ("id", "n", "policy", "fpp_bits", "per_bucket_capacity", "buckets", "cache_bytes", "probes", "backing_bytes")) + "\n"
    return {"selection.json": json.dumps(selection, indent=2) + "\n", "candidate-ledger.csv": output.getvalue(), "constructors.tsv": tsv}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    source_check()
    outputs = rendered()
    for name, value in outputs.items():
        path = HERE / name
        if args.write:
            need(not path.exists(), "Preserve previous plan output")
            path.write_text(value)
        else:
            need(path.read_text() == value, "Frozen plan output drift")
    selection = json.loads(outputs["selection.json"])
    print(json.dumps({key: selection[key] for key in ("selected_rows", "candidate_capacities", "controls", "filter_workloads_run")}))


if __name__ == "__main__":
    main()
