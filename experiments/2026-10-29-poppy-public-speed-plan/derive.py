#!/usr/bin/env python3
"""Select public mappings and every prior native/external leader before timing."""
import csv
import hashlib
import io
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GEOMETRY_COMMIT = "c6b8d9ad6e0e3179ed1304601451bb25cad23b13"
TRAINING_COMMIT = "434747e8d83b1ad1f43a1ce01149afc1d41fceb7"
ACCURACY_COMMIT = "cd6c60a0b6aad40dccacdef9e39b86510d43041f"
K12_COMMIT = "72625673e6b5bb57874a5fa53e04d23ffb8c6ab2"


def derive():
    origins = {}

    def read(commit, name):
        data = subprocess.check_output(["git", "show", commit + ":" + name], cwd=ROOT)
        assert (ROOT / name).read_bytes() == data, "Changed committed input: " + name
        origins[name] = dict(commit=commit, sha256=hashlib.sha256(data).hexdigest())
        return data.decode()

    selected = json.loads(
        read(
            GEOMETRY_COMMIT,
            "experiments/2026-10-29-poppy-public-geometry/selection.json",
        )
    )
    pinned = json.loads(
        read(
            GEOMETRY_COMMIT,
            "experiments/2026-10-29-poppy-public-constructor-plan/source-pins.json",
        )
    )
    upstream = {}
    for item in pinned["files"]:
        path = ROOT / "build/poppy-source" / item["path"]
        data = path.read_bytes()
        git_data = subprocess.check_output(
            ["git", "show", pinned["commit"] + ":" + item["path"]],
            cwd=ROOT / "build/poppy-source",
        )
        assert data == git_data
        assert (
            hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
            == item["git_blob_sha"]
        )
        upstream[item["path"]] = dict(
            git_blob_sha=item["git_blob_sha"], sha256=hashlib.sha256(data).hexdigest()
        )
    groups = {}
    for row in selected["rows"]:
        groups.setdefault(tuple(row["mapping_alias_group"]), []).append(row)
    assert len(groups) == 49
    configurations, excluded = [], []
    for key, aliases in groups.items():
        first = aliases[0]  # Original source ledger order; no timing/FPR ranker.
        cap = next(
            (c for c in (16, 24, 32) if first["backing_bytes"] * 8 <= first["n"] * c),
            None,
        )
        point = dict(
            filter="PoppyPublic" + first["id"].split("-")[1],
            keys=first["n"],
            actual_bytes=first["backing_bytes"],
            source_mapping=list(key),
            canonical_constructor=first,
            source_alias_ids=[x["id"] for x in aliases],
            owner="poppy_external",
        )
        if cap is None:
            point["reason"] = (
                "Above maximum32-bit actual byte ceiling; retained in complete accuracy archive"
            )
            excluded.append(point)
        else:
            point["run_budget_bpk"] = cap
            configurations.append(point)
    assert len(configurations) == 47 and len(excluded) == 2

    retained = {}
    view_count = 0
    for kind in ("query", "build"):
        name = (
            "experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/report/"
            + kind
            + "-views.csv"
        )
        for index, view in enumerate(
            csv.DictReader(io.StringIO(read(TRAINING_COMMIT, name)))
        ):
            view_count += 1
            for owner in ("production_native", "external", "native_experimental"):
                for leader in json.loads(view[owner + "_leaders"]):
                    n, size = int(view["keys"]), int(leader["filter_bytes"])
                    key = (n, leader["filter"], size)
                    if key not in retained:
                        bpk, remainder = divmod(size * 8, n)
                        assert remainder == 0 and bpk in (16, 24, 32)
                        retained[key] = dict(
                            filter=leader["filter"],
                            keys=n,
                            actual_bytes=size,
                            run_budget_bpk=bpk,
                            owner=owner,
                            source_reasons=[],
                        )
                    retained[key]["source_reasons"].append(
                        dict(
                            kind=kind,
                            index=index,
                            owner=owner,
                            batch=int(view["batch"]),
                            cap_bpk=int(view["cap_bpk"]),
                            fpr_ceiling=float(view["fpr_ceiling"]),
                            metric=view["metric"],
                        )
                    )
    assert view_count == 432 and len(retained) == 32
    configurations.extend(retained[k] for k in sorted(retained))
    for n in (65536, 33554432):
        configurations.append(
            dict(
                filter="FourSectorRange12BloomFilter",
                keys=n,
                actual_bytes=n * 3,
                run_budget_bpk=24,
                owner="optional_native_k12",
                reason="Fixed original K12@24 bulk control; failed two-hint candidate excluded",
            )
        )
    assert len(configurations) == 81
    for point in configurations:
        point["actual_bpk"] = point["actual_bytes"] * 8 / point["keys"]
        point["configuration_id"] = (
            f"{point['keys']}:{point['filter']}:{point['actual_bytes']}"
        )
    configurations.sort(key=lambda r: (r["keys"], r["run_budget_bpk"], r["filter"]))
    assert len({r["configuration_id"] for r in configurations}) == 81

    # Bind completed Poppy observations for caller reproduction, not selection.
    quality = json.loads(
        read(
            ACCURACY_COMMIT,
            "experiments/2026-10-29-poppy-public-accuracy-analysis/report/quality.json",
        )
    )
    observed = {r["id"]: r for r in quality}
    for point in configurations:
        if point["owner"] == "poppy_external":
            first = observed[point["canonical_constructor"]["id"]]
            fields = (
                "actual_bytes",
                "false_positives",
                "mixed_false_positives",
                "result_checksum",
                "insertions_returned_new",
            )
            assert all(
                all(observed[i][f] == first[f] for f in fields)
                for i in point["source_alias_ids"]
            )
            point["prior_observation"] = {f: first[f] for f in fields}
    read(
        K12_COMMIT,
        "experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark/src/main.rs",
    )
    read(
        K12_COMMIT,
        "experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark/src/geometry.rs",
    )
    return dict(
        scope="Source-selected public Poppy mappings plus every strongest committed Rust query/build control",
        origins=origins,
        prior_views=432,
        poppy_source_mappings=49,
        public_upstream=dict(commit=pinned["commit"], files=upstream),
        configurations=configurations,
        over_maximum_byte_cap=excluded,
        selection_uses_latency_for="Committed432-view retained controls only; all leader ties retained",
        poppy_selection_uses="Source mapping identity, original ledger order and actual byte cap only; no quality or timing pruning",
        formal_rows=486,
        formal_processes=36,
        unpooled_api_geometry_quality_records=81,
        construction_seed=42,
        seed_scope="Seen training input; two opposite launch/filter orders, not fresh seeds",
    )


if __name__ == "__main__":
    value = derive()
    path = HERE / "selection.json"
    content = json.dumps(value, indent=2) + "\n"
    if path.exists():
        assert path.read_text() == content, "Preserve fixed source selection"
    else:
        path.write_text(content)
    print(
        json.dumps(
            {
                k: value[k]
                for k in (
                    "prior_views",
                    "poppy_source_mappings",
                    "formal_rows",
                    "formal_processes",
                    "unpooled_api_geometry_quality_records",
                )
            }
        )
    )
