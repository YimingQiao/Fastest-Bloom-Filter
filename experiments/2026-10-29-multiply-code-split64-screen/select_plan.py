#!/usr/bin/env python3
"""Select fixed geometry rows, with no filter construction or measurements."""
import argparse
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
CANDIDATE = "MultiplyCodeSplit64RangeExperiment"


def select(grid, parent):
    if len(grid["registry"]) != 76 or len(set(grid["registry"])) != 76:
        raise ValueError("Expected76 distinct registered APIs")
    if grid["unsupported"] or len(grid["configurations"]) != 1016:
        raise ValueError("Unexpected complete allocation grid")
    by_id = {r["configuration_id"]: r for r in grid["configurations"]}
    if len(by_id) != len(grid["configurations"]):
        raise ValueError("Repeated effective geometry")
    retained = []
    for old in parent["configurations"]:
        new = by_id.get(old["configuration_id"])
        if new is None:
            raise ValueError("Missing retained geometry: " + old["filter"])
        for field in ("filter", "keys", "requested_bpk", "filter_bytes", "logical_bytes", "geometry_kind",
                      "unit_bytes", "unit_count", "effective_probes", "probe_policy", "constructor_argument",
                      "page_level", "native_constructor_bpk", "implementation_origin", "calibration_identity"):
            if new[field] != old[field]:
                raise ValueError("Retained geometry changed: " + old["filter"] + "/" + field)
        retained.append(new)
    if len(retained) != 62:
        raise ValueError("Expected62 frozen retained configurations")
    added = [r for r in grid["configurations"] if r["filter"] == CANDIDATE and int(r["requested_bpk"]) in (16,24,28,32)]
    if len(added) != 8:
        raise ValueError("Expected eight multiply-code geometries")
    for row in added:
        if (row["probe_policy"] != "multiply_low32_u64_9e3779b97f4a7c15_byte6"
                or row["implementation_origin"] != "project_experiment"
                or row["calibration_identity"] in {r["calibration_identity"] for r in retained}):
            raise ValueError("Multiply-code ownership/quality identity changed")
    selected = retained + added
    cases = {}
    for row in selected:
        key = (row["key_power"], int(row["requested_bpk"]))
        cases.setdefault(key, []).append(row)
    jobs = [dict(key_power=power, budget_bpk=budget,
                 filters=[r["filter"] for r in rows], configuration_ids=[r["configuration_id"] for r in rows])
            for (power,budget), rows in sorted(cases.items())]
    return dict(scope="Fixed70-row training comparison; no timing yet", seed=42, configurations=selected, cases=jobs,
                rows=len(selected), retained_configurations=62, added_multiply_configurations=8,
                primary_caps_bpk=[16,32], fpr_ceilings=[.01,.001,.0001], batch=4096, query_power=22,
                query_repeats=6, calibration_power=24, hit_percent=50, build_repeats=0)


def main():
    if not __debug__:
        raise ValueError("Normal Python required")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--grid", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    plan = select(json.loads(args.grid.read_text()), json.loads((HERE / "parent-selection.json").read_text()))
    with args.output.open("x") as stream:
        stream.write(json.dumps(plan, indent=2)+"\n")
    print(f"Selected{plan['rows']} fixed geometries in{len(plan['cases'])} cases; no timing")


if __name__ == "__main__":
    main()
