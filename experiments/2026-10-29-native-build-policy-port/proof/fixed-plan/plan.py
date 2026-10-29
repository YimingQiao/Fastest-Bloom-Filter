"""Fixed fresh-seed confirmation ledger; no filter, compiler, or timer execution."""
from collections import Counter
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
SEEDS = (74381, 164321)
FAMILIES = ("Split64", "Split64Range")
LANGUAGES = ("cpp", "rust")
REQUESTS = (4, 8)
SCHEDULE = (("serial", "control", "candidate"),
            ("candidate", "control", "serial"),
            ("serial", "candidate", "control"),
            ("control", "candidate", "serial"))


def scenarios(family):
    if family not in FAMILIES:
        raise ValueError("Unregistered family")
    large = 67108864 if family == "Split64" else 100663296
    above = 524288 if family == "Split64" else 262208
    return [
        dict(scenario=0, name="small_empty_uniform", bytes=262144, batch_n=65536,
             history_n=0, hotspot=False),
        dict(scenario=1, name="above_batch_empty_uniform", bytes=262144, batch_n=65537,
             history_n=0, hotspot=False),
        dict(scenario=2, name="small_prefilled_hotspot", bytes=262144, batch_n=65536,
             history_n=131072, hotspot=True),
        dict(scenario=3, name="above_bytes_empty_uniform", bytes=above, batch_n=65536,
             history_n=0, hotspot=False),
        dict(scenario=4, name="large_empty_uniform", bytes=large, batch_n=65536,
             history_n=0, hotspot=False),
        dict(scenario=5, name="large_prefilled_hotspot", bytes=large, batch_n=65536,
             history_n=large // 2, hotspot=True),
    ]


def ledger():
    # Both seeds use the same finite scope. The second reverses complete case
    # order, including language order; no timing-derived sort or seed selection.
    base = [(family, scenario, request, language)
            for scenario in range(6) for family in FAMILIES
            for request in REQUESTS for language in LANGUAGES]
    result = []
    for seed_index, seed in enumerate(SEEDS):
        ordered = base if seed_index == 0 else list(reversed(base))
        for family, scenario, request, language in ordered:
            case = dict(scenarios(family)[scenario])
            case.update(case_index=len(result), family=family, language=language,
                        requested=request, seed=seed, repeats=4,
                        input_base=seed << 42,
                        contracts=["insert"] + ([] if case["history_n"] else ["allocate_insert"]))
            result.append(case)
    return result


def validate(cases):
    if cases != ledger():
        raise ValueError("Fixed ordered confirmation ledger changed")
    keys = [(c["language"], c["family"], c["scenario"], c["requested"], c["seed"]) for c in cases]
    if len(cases) != 96 or len(set(keys)) != 96:
        raise ValueError("Expected exactly96 paired cases")
    positions = {arm: Counter(row.index(arm) for row in SCHEDULE)
                 for arm in ("serial", "control", "candidate")}
    if positions["control"] != positions["candidate"] or positions["serial"][1]:
        raise ValueError("Pair position balance changed")
    if [row.index("control") < row.index("candidate") for row in SCHEDULE] != [True, False, False, True]:
        raise ValueError("Pair ABBA changed")
    if any(c["input_base"] + (2 << 40) + 32771 >= (c["seed"] + 1) << 42 for c in cases):
        raise ValueError("Raw input domains overlap seed stride")
    populated = [c for c in cases if c["history_n"]]
    if len(populated) != 32 or any(c["contracts"] != ["insert"] for c in populated):
        raise ValueError("Populated incremental scope changed")
    return dict(paired_cases=96, variant_rows=192, serial_reference_records=96,
                populated_paired_cases=32, empty_paired_cases=64,
                paired_contracts=sum(len(c["contracts"]) for c in cases),
                variant_metric_records=2 * sum(len(c["contracts"]) for c in cases),
                serial_metric_records=sum(len(c["contracts"]) for c in cases),
                timed_filter_lifetimes=12 * sum(len(c["contracts"]) for c in cases),
                untimed_oracle_filter_lifetimes=96)


if __name__ == "__main__":
    cases = ledger()
    print(json.dumps(dict(counts=validate(cases), cases=cases), indent=2))
