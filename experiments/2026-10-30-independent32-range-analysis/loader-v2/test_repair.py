"""Three synthetic guards for the proof-first seal.py repair; no experiment data."""
import copy
from contextlib import contextmanager
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import run

class RepairGuards(unittest.TestCase):
    @contextmanager
    def fixture(self, wrong_hash=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            caller = root / 'caller'
            caller.mkdir()
            source = b'# frozen caller helper\n'
            seal = b'# additive proof sealer\n'
            (caller / 'source.py').write_bytes(source)
            (caller / 'seal.py').write_bytes(seal)
            h = lambda b: hashlib.sha256(b).hexdigest()
            archive = dict(complete=True, source_commit='1'*40,
                files={**{f'capture-{i}.txt':h(b'x') for i in range(172)},
                       'seal.py': '0'*64 if wrong_hash else h(seal)})
            proof = dict(complete=True, source_commit='1'*40, preparation_sha256='a'*64,
                manual_review=dict(complete=True), all_binary_sha256={'normal':'b'*64,'asan':'c'*64},
                compiler_consumed_input_sha256={f'input-{i}':'d'*64 for i in range(570)},
                normal_executable=dict(path='normal',sha256='b'*64))
            manifest = dict(files={'source.py':dict(bytes=len(source),sha256=h(source))})
            binding = dict(proof_commit='2'*40, caller_commit='1'*40,
                caller_manifest_sha256='a'*64, proof_archive_sha256='e'*64,
                compiled_proof_sha256='f'*64)
            real_committed = run.committed
            def committed(commit, path, expected=None, size=None):
                name = Path(path).name
                if name == 'COMPLETE_PROOF_ARCHIVE.json':
                    return json.dumps(archive).encode()
                if name == 'COMPILED_PROOF.json':
                    return json.dumps(proof).encode()
                if name == 'PREPARATION.json':
                    return json.dumps(manifest).encode()
                if name == 'seal.py':
                    return real_committed(commit, path, expected, size)
                data = source if name == 'source.py' else b'x'
                self.assertEqual(h(data), expected)
                if size is not None:
                    self.assertEqual(len(data), size)
                return data
            with patch.object(run,'CALLER',caller), patch.object(run,'ROOT',root), \
                 patch.object(run,'committed',side_effect=committed), \
                 patch.object(run.subprocess,'check_output',return_value=seal) as git:
                yield caller, binding, proof, archive, git

    def test_known_proof_sealer_only_after_verified_proof(self):
        with self.fixture() as (caller,binding,proof,archive,git):
            with self.assertRaisesRegex(ValueError,'uninventoried'):
                run.manifest_files(caller,'1'*40)
            actual, allowed = run.verify_proof(binding)
            self.assertEqual(actual, proof)
            self.assertEqual(allowed,{(caller/'seal.py').resolve()})
            self.assertEqual(git.call_count,1)
            paths = run.manifest_files(caller,'1'*40,proof_python=allowed)
            self.assertNotIn((caller/'seal.py').resolve(),paths)
            self.assertIn((caller/'source.py').resolve(),paths)

    def test_unknown_extra_remains_rejected(self):
        with self.fixture() as (caller,binding,proof,archive,git):
            _, allowed = run.verify_proof(binding)
            (caller/'unknown.py').write_text('# not inventoried\n')
            with self.assertRaisesRegex(ValueError,'uninventoried'):
                run.manifest_files(caller,'1'*40,proof_python=allowed)
            archive['files']['unknown.py'] = archive['files'].pop('capture-0.txt')
            with self.assertRaisesRegex(ValueError,'unexpected caller proof Python inventory'):
                run.verify_proof(binding)
            with self.assertRaisesRegex(ValueError,'unexpected proof Python allowance'):
                run.manifest_files(caller,'1'*40,proof_python=allowed|{(caller/'unknown.py').resolve()})

    def test_wrong_sealer_hash_rejected_before_allowance(self):
        with self.fixture(wrong_hash=True) as (caller,binding,proof,archive,git):
            with self.assertRaisesRegex(ValueError,'artifact SHA mismatch'):
                run.verify_proof(binding)
            git.assert_not_called()

if __name__=='__main__':
    unittest.main()

