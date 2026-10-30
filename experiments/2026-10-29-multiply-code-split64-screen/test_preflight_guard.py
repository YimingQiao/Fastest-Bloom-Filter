"""Offline corruption and actual-FD guard tests; no Bloom filter is executed."""
import fcntl
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import preflight_guard as guard
import source_guard as lease


class Guards(unittest.TestCase):
    def test_optimized_preflight_stops_before_argument_or_output_processing(self):
        result = subprocess.run([sys.executable, "-O", str(guard.HERE / "preflight.py")], capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("do not use -O", result.stderr)
        self.assertEqual(result.stdout, "")

    def test_initial_proposal_checks_committed_and_worktree_bytes(self):
        self.assertEqual(len(guard.initial_snapshot()), 27)
        real = guard.blob
        def corrupt(commit, path):
            data = real(commit, path)
            return data + b" " if path.name == "protocol.json" else data
        with patch.object(guard, "blob", side_effect=corrupt):
            with self.assertRaisesRegex(ValueError, "proposal byte"):
                guard.initial_snapshot()

    def test_commit_and_path_escape_rejected_before_git(self):
        with patch.object(guard.subprocess, "check_output") as tool:
            with self.assertRaisesRegex(ValueError, "Full source commit"):
                guard.blob("HEAD", guard.HERE / "protocol.json")
            with self.assertRaisesRegex(ValueError, "escapes repository"):
                guard.blob(guard.INITIAL, Path("/tmp/outside-source"))
            tool.assert_not_called()

    def test_wrong_env_cpu_and_affinity_are_rejected(self):
        with patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket0-cpu2"}):
            with self.assertRaises(ValueError):
                lease.require_lease(3)
        with patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(lease.os, "sched_getaffinity", return_value={2}):
            with self.assertRaises(ValueError):
                lease.require_lease(3)

    def test_owned_real_descriptor_succeeds(self):
        with tempfile.TemporaryFile() as stream:
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX)
            with patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(lease.os, "sched_getaffinity", return_value={3}), patch.object(lease.os, "listdir", return_value=[str(stream.fileno())]), patch.object(lease.os, "readlink", return_value="/tmp/fastest-bf-socket1.lock"):
                value = lease.require_lease(3)
                self.assertEqual(value["inherited_lock_descriptors"], [stream.fileno()])

    def test_separate_fd_cannot_claim_another_holder_lock(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "lock"
            with path.open("w") as holder, path.open("r") as other:
                fcntl.flock(holder.fileno(), fcntl.LOCK_EX)
                with patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(lease.os, "sched_getaffinity", return_value={3}), patch.object(lease.os, "listdir", return_value=[str(other.fileno())]), patch.object(lease.os, "readlink", return_value="/tmp/fastest-bf-socket1.lock"):
                    with self.assertRaises(BlockingIOError):
                        lease.require_lease(3)

    def test_consumed_repo_header_must_be_pinned(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            source = root / "source.hpp"
            source.write_text("known header\n")
            for index in range(4):
                (build / f"target{index}.o.d").write_text(f"target{index}.o: {source}\n")
            with patch.object(guard, "ROOT", root):
                actual = guard.consumed_dependencies(build, {"source.hpp": guard.sha(source)})
                self.assertEqual(actual["repository_sha256"], {"source.hpp": guard.sha(source)})
                with self.assertRaisesRegex(ValueError, "unpinned repository"):
                    guard.consumed_dependencies(build, {})


if __name__ == "__main__":
    unittest.main()
