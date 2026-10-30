"""Prespecify the first12-config speed screen without running/JITing filters."""
import hashlib
import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BRIDGE = ROOT / "benchmarks/blowchoc-external"
HELD = ROOT / "experiments/2026-10-29-blowchoc-heldout-accuracy"
spec = importlib.util.spec_from_file_location("construction_protocol", HELD / "prepare.py")
helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(helpers)


def cases(key_powers, requested, query_power, calibration_power):
    configs = json.loads((HELD / "protocol.json").read_text())["configs"]
    output = []
    for power in key_powers:
        for bpk in requested:
            n, q, budget = 1 << power, 1 << query_power, (1 << power) * bpk // 4
            blocks = (budget - 448) // 64
            if blocks % 2 == 0:
                blocks -= 1
            assert blocks * 64 + 448 == budget
            base = helpers.first_random(42) % ((1 << 32) - n - q)
            case = dict(id=f"n{power}-requested{bpk}", keys=n, queries=q, key_power=power,
                        requested_bpk=bpk, actual_bpk=8 * budget // n, payload_bytes=budget,
                        seed=42, construction_seed=113, key_base=base,
                        inserted_raw_interval=[base, base + n], query_negative_raw_bounds=[base + n, base + n + q],
                        calibration_raw_interval=[base + n + q, base + n + q + (1 << calibration_power)],
                        constructions={})
            for config in configs:
                if config["family"] == "blowchoc":
                    case["constructions"][config["filter"]] = helpers.construction(
                        blocks, config["choices"], config["probes"], config["version"], 113)
            output.append(case)
    return output


if __name__ == "__main__":
    held = json.loads((HELD / "protocol.json").read_text())
    protocol = {key: held[key] for key in ("bridge_commit", "bridge_freeze_sha256", "upstream_commit", "native_source_commit",
                                         "native_library", "native_library_sha256", "configs", "expected_runtime", "compiler", "native_flags")}
    protocol.update(stage="prespecified first query-throughput training screen; no global fastest claim",
                    heldout_accuracy_commit="192b60ac7011013dfef82cb46c0260677e8633de",
                    heldout_accuracy_freeze_sha256=hashlib.sha256((HELD / "FREEZE.json").read_bytes()).hexdigest(),
                    cases=cases((16, 25), (8, 16), 22, 24), expected_rows=48, batch=4096,
                    repeats=6, hit_percent=50, calibration_power=24, query_power=22,
                    cpu=3, socket=1, lock="/tmp/fastest-bf-socket1.lock",
                    build_metrics="unmeasured; JSON null and exported CSV NaN; one canonical prehashed construction",
                    api_contracts=["prehashed", "common-fused", "common-staged"],
                    phase_policy="All six permutations of three query modes exactly once; identical schedule for all12 configs.",
                    boundary="One prepared compiled whole-array call per query phase; unchanged frozen adapter and native library.",
                    quality="cal24 after queries; same actual16/32bpk cap including448B backing slack; positions2*K disclosed; no pooling repeated or different construction streams.",
                    scope="Only actual16/32bpk grid; intermediate12/14/etc exact-byte rivals are outside this initial screen.",
                    validation="Actual-size complete bitmap/oracle and later-factory rebuild checks before canonical build; every inserted key/noFN; complete answers/guards/checksum outside every query timer; weakref release after each filter.",
                    result_policy="All three API contracts separate; record raw trials/min/median/max and individual losses. This uses input42/construction113 as training-speed data; any performance claim requires separately prespecified fresh held-out inputs/constructions.",
                    performance_authorization="No execution until source/protocol/native binary freeze is reviewed and committed, followed by explicit lease.")
    (HERE / "protocol.json").write_text(json.dumps(protocol, indent=2) + "\n")
    print("Prespecified4 cases/48 rows,32 construction hash sets; no JIT or speed run.")
