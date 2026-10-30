#!/usr/bin/env python3
"""Include-route-only repair; native/checker/timed bodies remain frozen."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;PARENT=HERE.parent;ROOT=HERE.parents[3]
SOURCE='b7bec22fe6b88fe0b0382c6fb53a939dcf97f211';PREFIX='experiments/2026-10-29-k12-prefetch-line-or/caller/'
def blob(name):return subprocess.check_output(['git','show',SOURCE+':'+PREFIX+name],cwd=ROOT).decode()
def files():
 old=blob('compare_benchmark.cpp');new=old
 for a,b in [('#include "../control.hpp"','#include "../../control.hpp"'),('#include "../candidate.hpp"','#include "../../conditional.hpp"'),('#include "geometry.hpp"','#include "../geometry.hpp"')]:assert new.count(a)==1;new=new.replace(a,b)
 assert new[new.index('using namespace bloom_filters;'):]==old[old.index('using namespace bloom_filters;'):]
 cmake=blob('CMakeLists.txt').replace('add_executable(check check.cpp)','add_executable(check ../check.cpp)')
 driver=blob('validate.py').replace('from source_guard import HERE,BASE,ROOT,OLD,sha,verify','import sys\nsys.path.insert(0,str(Path(__file__).resolve().parent.parent))\nfrom repair_guard import HERE,PARENT,BASE,ROOT,OLD,sha,verify')
 driver=driver.replace("'k12-prefetch-line-or-v1-cpu2-","'k12-prefetch-line-or-v2-cpu2-")
 driver=driver.replace("HERE/'check.cpp'","PARENT/'check.cpp'").replace("HERE/'geometry.hpp'","PARENT/'geometry.hpp'")
 # Prefixes change only emitted artifact locations and dependency paths.
 output={'compare_benchmark.cpp':new,'CMakeLists.txt':cmake,'validate.py':driver}
 for name,before in [('compare_benchmark.cpp',old),('CMakeLists.txt',blob('CMakeLists.txt')),('validate.py',blob('validate.py'))]:
  output[name+'.patch']=''.join(difflib.unified_diff(before.splitlines(True),output[name].splitlines(True),fromfile='frozen-v1/'+name,tofile='repair-v2/'+name))
 return output
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args()
 for name,text in files().items():
  if a.write:(HERE/name).write_text(text)
  else:assert(HERE/name).read_text()==text,name
 print('PASS include routing and fresh paths only; no compiler/BF')
