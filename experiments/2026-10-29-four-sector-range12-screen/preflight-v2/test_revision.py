import hashlib
from pathlib import Path
import tempfile
import unittest
from revision_guard import HERE,derived
class Tests(unittest.TestCase):
    def test_exact_driver_delta(self):self.assertEqual((HERE/'validate.py').read_text(),derived())
    def test_cxx_driver_name_and_content_hash(self):
        with tempfile.TemporaryDirectory()as tmp:
            root=Path(tmp);target=root/'clang';target.write_bytes(b'compiler fixture');link=root/'clang++';link.symlink_to(target)
            self.assertEqual(link.absolute().name,'clang++');self.assertEqual(link.resolve().name,'clang')
            self.assertEqual(hashlib.sha256(link.absolute().read_bytes()).digest(),hashlib.sha256(target.read_bytes()).digest())
if __name__=='__main__':unittest.main()
