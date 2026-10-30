#!/usr/bin/env python3
"""Offline completed-matrix reconstruction, with an optional live-file audit."""
import argparse
import json
from screen_contract import HERE, need, sha, audit
from freeze import PROOF, validate_placement, verify


def load(commit, output=HERE / "results-v1", live=False):
    sources, compiled = verify(commit, live=live)
    metadata = json.loads((output / "metadata.json").read_text())
    need(metadata["complete"] is True and metadata["final_frozen_inputs_equal"] is True, "Incomplete run")
    need(metadata["source_commit"] == commit and metadata["proof_commit"] == PROOF and metadata["source_sha256"] == sources, "Wrong source/proof closure")
    need(metadata["compiled_freeze_sha256"] == sha(HERE.parent / "provenance-v3/combined-proof.json") and
         metadata["protocol_sha256"] == sha(HERE / "protocol.json"), "Frozen descriptors changed")
    binaries = compiled["selected_normal_executables"]
    need(metadata["binaries"] == binaries, "Wrong measured binaries")
    validate_placement(metadata["placement"])
    return audit(output, metadata, binaries, metadata["placement"]["lease"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--verify-live", action="store_true")
    args = parser.parse_args()
    records, counts = load(args.source_commit, live=args.verify_live)
    print("PASS complete raw/aggregate audit", counts)
