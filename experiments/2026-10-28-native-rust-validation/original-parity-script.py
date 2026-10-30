import csv,io,json,subprocess
from pathlib import Path
root=Path('/home/yiming/projects/fastest-bf-lab')
fields=['filter_bytes','result_checksum','false_positives','absent_queries','calibration_absent_queries','calibration_false_positives']
cases=[]
for bpk in [4,8,16]:
 for hit in [0,50,100]:
  for batch,ins in [(1,1),(17,3),(4096,65536)]:cases.append((16,bpk,hit,14,batch,1,731,ins,16))
for batch,ins in [(3,4),(15,7),(31,17),(4096,1048576)]:cases.append((20,16,50,16,batch,1,20261028,ins,18))
rows=[]
for case in cases:
 parsed=[]
 for exe,selection in [('build/native/compare_benchmark','FourSectorBloomFilter,Split64BloomFilter'),('rust/target/release/compare_benchmark','FourSectorBloomFilter,Split64BloomFilter'),('benchmarks/rust-external/target/release/compare_benchmark','FourSector16K8Experimental,Split64Experimental')]:
  cmd=['taskset','-c','3',str(root/exe),*map(str,case[:7]),selection,*map(str,case[7:])]
  result=subprocess.run(cmd,check=True,capture_output=True,text=True)
  data=list(csv.DictReader(io.StringIO(result.stdout)))
  assert len(data)==2
  parsed.append({r['filter']:r for r in data})
  rows.extend(data)
 for native,proto in [('FourSectorBloomFilter','FourSector16K8Experimental'),('Split64BloomFilter','Split64Experimental')]:
  for field in fields:
   a=[parsed[0][native][field],parsed[1][native][field],parsed[2][proto][field]]
   assert len(set(a))==1,(case,native,field,a)
Path('/tmp/native-layout-parity.json').write_text(json.dumps(rows,indent=2))
print('PASS:',len(cases),'workloads × 2 layouts: native C++ = native Rust = frozen Rust prototype')
# Preserve default three rows and compare both languages by selected family.
for threads in [1,3,7]:
 for selection,expected in [('',3),('all',7),('FourSector,Split64',4)]:
  pair=[]
  for exe in ['build/native/parallel_benchmark','rust/target/release/parallel_benchmark']:
   cmd=['taskset','-c','3',str(root/exe),'16','8','16',str(threads),'1','731','50']
   if selection:cmd.append(selection)
   data=list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
   assert len(data)==expected,(cmd,len(data))
   pair.append({r['filter']:r for r in data})
  assert pair[0].keys()==pair[1].keys()
  for name in pair[0]:
   for field in ['filter_bytes','result_checksum','false_positives','absent_queries','build_workers','query_workers']:
    assert pair[0][name][field]==pair[1][name][field],(threads,selection,name,field,pair[0][name][field],pair[1][name][field])
print('PASS: 9 native C++/Rust parallel cases; default/selected/all rows and memory/checksums/workers match')
