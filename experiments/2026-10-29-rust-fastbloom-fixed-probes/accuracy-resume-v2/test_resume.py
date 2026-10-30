import json
from pathlib import Path
import subprocess
import sys
import unittest
from resume import compiler_executable, test_executable

BASE = "/tmp/fastest-bf-fastbloom-fixed-k-preflight/accuracy-validation-v1/asan/"


class ArtifactGuard(unittest.TestCase):
    def test_exact_recorded_nested_path(self):
        path = BASE + "x86_64-unknown-linux-gnu/release/build/package/hash/out/accuracy-123"
        self.assertEqual(test_executable("Running unittests src/main.rs (" + path + ")\n"), Path(path))

    def test_missing_multiple_or_unrelated_test_path_rejected(self):
        for text in ["", "Running unittests src/main.rs (/tmp/accuracy-123)\n",
                     "Running unittests src/main.rs (" + BASE + "accuracy-1)\nRunning unittests src/main.rs (" + BASE + "accuracy-2)\n"]:
            with self.assertRaises(ValueError): test_executable(text)

    def artifact(self):
        return dict(reason="compiler-artifact", target=dict(name="accuracy", kind=["bin"]),
                    profile=dict(test=False), executable=BASE + "x86_64-unknown-linux-gnu/release/accuracy")

    def test_structured_standalone_artifact(self):
        value = self.artifact()
        self.assertEqual(compiler_executable(json.dumps(value) + '\n' + json.dumps(dict(reason="build-finished", success=True))), Path(value["executable"]))

    def test_duplicate_test_or_outside_structured_artifact_rejected(self):
        for change in [{"executable": "/tmp/accuracy"}, {"profile": {"test": True}}, {"target": {"name": "accuracy", "kind": ["lib"]}}]:
            value = dict(self.artifact(), **change)
            with self.assertRaises(ValueError): compiler_executable(json.dumps(value))
        line = json.dumps(self.artifact())
        with self.assertRaises(ValueError): compiler_executable(line + '\n' + line)

    def test_optimized_python_stops_before_lease_or_build(self):
        result = subprocess.run([sys.executable, "-O", str(Path(__file__).with_name("resume.py"))], capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(result.stdout)
        self.assertIn(b"Use Python without -O", result.stderr)


if __name__ == "__main__": unittest.main()
