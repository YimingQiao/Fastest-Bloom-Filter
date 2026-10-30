"""Synthetic full raw/aggregate archive tests; no filter process is started."""
import copy
import csv
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import audit
import contract as c
import source_guard as sg
from test_contract import fixture


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


class ArchiveTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.stage = Path(self.tmp.name)
        self.out = self.stage / "confirmation"
        self.out.mkdir()
        self.p, self.reg, self.rows = fixture()
        (self.stage / "protocol.json").write_bytes((sg.STAGE / "protocol.json").read_bytes())
        self.anchor = {"scope": "synthetic source guard stub; ancestry is tested separately"}
        self.meta = dict(complete=True, rows=144, source_commit="0" * 40,
                         compiled_source_commit=self.p["source_commit"], binary=self.p["binary"],
                         binary_sha256=self.p["binary_sha256"], anchor=self.anchor,
                         protocol_sha256=sg.sha(self.stage / "protocol.json"),
                         lease=dict(cpu=3, socket=1, affinity=[3], lock_path="/tmp/fastest-bf-socket1.lock",
                                    inherited_lock_descriptors=[3],
                                    numa_policy="CPU affinity only; no explicit NUMA memory binding"), cases=[])
        for i, case in enumerate(self.p["cases"]):
            stem = f"case-{i:02d}-s{case['seed']}-q{case['batch']}"
            stdout, stderr = self.out / (stem + ".stdout"), self.out / (stem + ".stderr")
            with stdout.open("w", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=c.raw_fields(), extrasaction="ignore", lineterminator="\n")
                writer.writeheader()
                writer.writerows(self.rows[i * 8:(i + 1) * 8])
            stderr.write_bytes(b"")
            self.meta["cases"].append(dict(case=case, command=c.command(self.p, case), returncode=0,
                                           validated=True, rows=8, stdout_file=stdout.name, stderr_file=stderr.name,
                                           stdout_sha256=sg.sha(stdout), stderr_sha256=sg.sha(stderr)))
        self.write_aggregate(self.rows)
        save(self.out / "quality.json", c.validate_matrix(self.rows, self.p, self.reg))
        self.meta["quality_sha256"] = sg.sha(self.out / "quality.json")
        self.seal()

    def write_aggregate(self, rows):
        with (self.out / "results.csv").open("w", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
        self.meta["results_sha256"] = sg.sha(self.out / "results.csv")

    def seal(self):
        save(self.out / "metadata.json", self.meta)
        save(self.out / "archive-manifest.json", dict(files={p.name: sg.sha(p) for p in self.out.iterdir()
                                                             if p.name != "archive-manifest.json"}))

    def check(self):
        with patch.object(audit, "STAGE", self.stage), patch.object(audit, "verify", return_value=self.anchor):
            return audit.audit()

    def test_complete_synthetic_archive(self):
        rows, q = self.check()
        self.assertEqual(rows, self.rows)
        self.assertEqual(len(q["mapping_seed_records"]), 36)

    def test_changed_command_even_resealed(self):
        self.meta["cases"][-1]["command"][5] = "32"
        self.seal()
        with self.assertRaises(ValueError):
            self.check()

    def test_aggregate_trial_change_even_resealed(self):
        changed = copy.deepcopy(self.rows)
        changed[-1]["lookup_trials_ns"] = "[2,2,3,4,5,6]"
        self.write_aggregate(changed)
        self.seal()
        with self.assertRaises(ValueError):
            self.check()

    def test_quality_pooling_even_resealed(self):
        q = json.loads((self.out / "quality.json").read_text())
        q["mapping_seed_records"][0]["negatives"] *= 3
        save(self.out / "quality.json", q)
        self.meta["quality_sha256"] = sg.sha(self.out / "quality.json")
        self.seal()
        with self.assertRaises(ValueError):
            self.check()

    def test_diagnostic_relabel_even_resealed(self):
        q = json.loads((self.out / "quality.json").read_text())
        next(r for r in q["across_seed_gate"] if r["filter"] == c.FOUR)["robust_eligible"] = True
        save(self.out / "quality.json", q)
        self.meta["quality_sha256"] = sg.sha(self.out / "quality.json")
        self.seal()
        with self.assertRaises(ValueError):
            self.check()

    def test_missing_raw_manifest_entry(self):
        path = self.out / "archive-manifest.json"
        manifest = json.loads(path.read_text())
        manifest["files"].pop(self.meta["cases"][-1]["stderr_file"])
        save(path, manifest)
        with self.assertRaises(ValueError):
            self.check()


if __name__ == "__main__":
    unittest.main()
