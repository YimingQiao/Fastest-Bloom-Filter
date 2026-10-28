"""Small inherited-FD fixtures; no benchmark, compilation, or CPU2 work is run."""
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

from source_guard import require_lease

HERE = Path(__file__).resolve().parent


class LeaseGuards(unittest.TestCase):
    def test_optimized_python_rejected_at_entry(self):
        p = subprocess.run([sys.executable, '-O', str(HERE/'run.py')], text=True, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertEqual(p.stdout, '')
        self.assertIn('without Python -O', p.stderr)

    def test_wrong_cpu_env_affinity(self):
        with mock.patch.dict(os.environ, {'BF_SOCKET_LEASE':'socket0-cpu2'}), mock.patch('os.sched_getaffinity', return_value={2}):
            with self.assertRaises(ValueError): require_lease(99)
        with mock.patch.dict(os.environ, {'BF_SOCKET_LEASE':'wrong'}), mock.patch('os.sched_getaffinity', return_value={2}):
            with self.assertRaises(ValueError): require_lease(2)
        with mock.patch.dict(os.environ, {'BF_SOCKET_LEASE':'socket0-cpu2'}), mock.patch('os.sched_getaffinity', return_value={3}):
            with self.assertRaises(ValueError): require_lease(2)

    def test_actual_inherited_descriptor(self):
        with tempfile.TemporaryDirectory(prefix='leaf-lease-test-') as directory:
            lock = Path(directory)/'test.lock'
            code = ('import json,os; from unittest import mock; from source_guard import require_lease; '
                    'os.environ["BF_SOCKET_LEASE"]="socket0-cpu2"; '
                    'm=mock.patch("os.sched_getaffinity",return_value={2});m.start(); '
                    'print(json.dumps(require_lease(2,'+repr(str(lock))+')))')
            # Affinity alone is mocked so these tiny fixtures do not use the
            # occupied measurement CPU. The descriptor and flock are real.
            p = subprocess.run([sys.executable,'-c',code],cwd=HERE,text=True,capture_output=True)
            self.assertNotEqual(p.returncode,0)
            self.assertIn('flock lease',p.stderr)
            with lock.open('w') as stream:
                fcntl.flock(stream.fileno(),fcntl.LOCK_EX)
                p = subprocess.run([sys.executable,'-c',code],cwd=HERE,text=True,capture_output=True,pass_fds=(stream.fileno(),),check=True)
                result=json.loads(p.stdout)
                self.assertEqual(result['lock_path'],str(lock.resolve()))
                self.assertEqual(result['inherited_lock_descriptors'],[stream.fileno()])


if __name__ == '__main__':unittest.main()
