#!/usr/bin/env python3
"""Mint a one-use order-only seed ledger; never execute a filter or read timing."""
import hashlib
import json
from pathlib import Path
import secrets
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = HERE.parent / "2026-10-29-multiply-code-split64-screen"
EXACT = HERE.parent / "2026-10-29-exact-budget-range"
sys.path.insert(0, str(SOURCE))
import order_oracle

FILTERS = [
    "MultiplyCodeSplit64RangeExperiment", "Split64BloomFilter",
    "Split64RangeExperiment", "FourSectorBloomFilter", "FastFilterFixed64",
    "Boost192Multi64K8", "RocksDBFastLocalBloom64K8", "RocksDBFastLocalBloom64K8Batch32",
]


def main():
    if not __debug__:
        raise ValueError("Do not run with Python -O")
    destination = HERE / "seed-ledger.json"
    if destination.exists():
        raise ValueError("Refuse to replace the fixed fresh-seed ledger")
    registry = order_oracle.source_registry(
        (SOURCE / "adapters.hpp").read_text(), (EXACT / "cpp-adapters.hpp").read_text(),
        (EXACT / "boost-adapters.hpp").read_text(), (EXACT / "rocks-adapters.hpp").read_text())
    ledger, selected, seen = [], {0: [], 7: []}, set()
    while min(len(v) for v in selected.values()) < 3:
        seed = secrets.randbits(64)
        if seed in seen or seed == 42:
            continue
        seen.add(seed)
        order = order_oracle.expected_order(registry, FILTERS, 1 << 16, 1 << 22, seed, 50)
        position = order.index(FILTERS[0])
        chosen = position in selected and len(selected[position]) < 3
        ledger.append(dict(seed=seed, multiply_position=position, selected=chosen, order=order))
        if chosen:
            selected[position].append(seed)
    seeds = [selected[position][i] for i in range(3) for position in (0, 7)]
    destination.write_text(json.dumps(dict(
        scope="Fresh seed selection uses only frozen source job order; no BF execution or timing input",
        source_commit="9e4362f1068d37d134ef8447a44146b52c1edc9f",
        oracle_sha256=hashlib.sha256((SOURCE / "order_oracle.py").read_bytes()).hexdigest(),
        registry=registry, filters=FILTERS, candidates=ledger,
        selected_seeds=seeds), indent=2) + "\n")
    print("Minted six order-stratified fresh seeds from", len(ledger), "candidate permutations; no filters run")


if __name__ == "__main__":
    main()
