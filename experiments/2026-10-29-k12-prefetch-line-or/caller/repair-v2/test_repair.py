import re,unittest
from pathlib import Path
from derive import HERE,PARENT,files,blob
class Tests(unittest.TestCase):
 def test_derivation(self):
  for name,text in files().items():self.assertEqual((HERE/name).read_text(),text)
 def test_all_local_include_routes(self):
  visited=set()
  def check(path):
   path=path.resolve()
   if path in visited:return
   visited.add(path);self.assertTrue(path.is_file(),str(path))
   for name in re.findall(r'^\s*#include "([^"]+)"',path.read_text(),re.M):check(path.parent/name)
  check(HERE/'compare_benchmark.cpp');check(PARENT/'check.cpp')
 def test_timed_suffix_exact(self):
  old=blob('compare_benchmark.cpp');new=(HERE/'compare_benchmark.cpp').read_text();token='using namespace bloom_filters;';self.assertEqual(old[old.index(token):],new[new.index(token):])
 def test_fresh_build_and_old_checker(self):
  text=(HERE/'validate.py').read_text();self.assertIn('k12-prefetch-line-or-v2-cpu2-',text);self.assertNotIn('k12-prefetch-line-or-v1-cpu2-',text);self.assertIn("PARENT/'check.cpp'",text);self.assertIn('add_executable(check ../check.cpp)',(HERE/'CMakeLists.txt').read_text())
if __name__=='__main__':unittest.main()
