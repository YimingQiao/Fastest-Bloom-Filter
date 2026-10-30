#!/usr/bin/env python3
"""Archive only: ELF address+size capture from the unchanged normal executable."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,json,os,re,shutil,subprocess,sys,traceback
from pathlib import Path
HERE=Path(__file__).resolve().parent;PROOF=HERE.parent
sys.path.insert(0,str(PROOF))
from bindings import ROOT,sha,save,verify,need
from source_guard import require_lease
from audit_reuse import audit
SOURCE='64a2cb2f4f847351e90848215564e5a9adfed771';RAW='b0d2d06491ffd9c5c24e945e03ed21a108044535'
BINARY='/tmp/fastest-bf-native-rust-k12-port-v2-cpu3/normal/release/native-rust-k12-port-proof'
DIGEST='6320a6e46303240e17ffcb62a5a2f6638ab7921433eb8f1bfe801469455ea6df'
def exact(commit,path):need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),'Committed archive drift')
def main():
 p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);args=p.parse_args();need(re.fullmatch('[0-9a-f]{40}',args.source_commit),'Full immutable source required')
 lease=require_lease(3);prepared=json.loads((HERE/'PREPARATION.json').read_text());exact(args.source_commit,HERE/'PREPARATION.json')
 for name,r in prepared['files'].items():
  f=HERE/name;exact(args.source_commit,f);need(sha(f)==r['sha256']and f.stat().st_size==r['bytes'],'Capture source drift')
 verify(SOURCE);reuse=audit();old=PROOF/'validation-v1';archive=json.loads((old/'ARCHIVE.json').read_text());exact(RAW,old/'ARCHIVE.json')
 for name,r in archive['files'].items():
  f=old/name;exact(RAW,f);need(sha(f)==r['sha256']and f.stat().st_size==r['bytes'],'Functional archive drift')
 prior=json.loads((old/'metadata.json').read_text());need(not prior['complete']and set(prior['fixtures'])=={'normal','disable-avx512','asan'},'Wrong preserved completed functionality')
 need(len({v['checksum']for v in prior['fixtures'].values()})==1 and prior['binaries'][BINARY]==DIGEST and sha(BINARY)==DIGEST,'Binary/parity identity drift')
 output=HERE/'results';need(not output.exists()and not output.is_symlink(),'Preserve previous capture');output.mkdir()
 meta=dict(complete=False,source_commit=args.source_commit,proof_source_commit=SOURCE,functional_archive_commit=RAW,original_metadata_complete=False,binary=BINARY,sha256=DIGEST,lease=lease,affinity=sorted(os.sched_getaffinity(0)),commands=[],selected=[],BF_executions=0,compiler_executions=0)
 def persist():save(output/'CAPTURE.json',meta)
 def run(label,tool,args):
  path=Path(shutil.which(tool)or'/missing').absolute();need(path.is_file(),'Tool missing');command=[str(path),*args];r=subprocess.run(command,capture_output=True)
  row=dict(label=label,command=command,tool_sha256=sha(path),returncode=r.returncode)
  for stream,data in [('stdout',r.stdout),('stderr',r.stderr)]:
   f=output/(label+'.'+stream);f.write_bytes(data);row[stream]=f.name;row[stream+'_sha256']=sha(f)
  meta['commands'].append(row);persist();need(r.returncode==0,'Capture failed '+label);return r.stdout.decode()
 persist()
 try:
  elf=run('elf-symbols','readelf',['--wide','--symbols',BINARY]);raw=run('nm-size','nm',['--defined-only','--print-size',BINARY]);dem=run('nm-size-demangled','nm',['--defined-only','--print-size','--demangle',BINARY])
  symbols=[]
  for line in elf.splitlines():
   cols=line.split(None,7)
   if len(cols)==8 and cols[0].endswith(':')and cols[0][:-1].isdigit()and cols[3]=='FUNC'and cols[6]not in ['UND','ABS']:
    symbols.append(dict(address=int(cols[1],16),size=int(cols[2],0),type=cols[3],binding=cols[4],section=cols[6],name=cols[7]))
  nm=[]
  for line in raw.splitlines():
   c=line.split(None,3)
   if len(c)==4 and re.fullmatch('[0-9a-fA-F]+',c[0])and re.fullmatch('[0-9a-fA-F]+',c[1]):nm.append(dict(address=int(c[0],16),size=int(c[1],16),kind=c[2],name=c[3]))
  required={'native_visible_pure','native_visible_fused','native_public_batch'};class_prefix='<fastest_bloom_filter::four_sector_range12::FourSectorRange12BloomFilter>::';targets=[]
  for line in dem.splitlines():
   c=line.split(None,3)
   if len(c)!=4 or not re.fullmatch('[0-9a-fA-F]+',c[0]):continue
   address,size,name=int(c[0],16),int(c[1],16),c[3]
   if name not in required and not(name.startswith(class_prefix)and any(x in name[len(class_prefix):]for x in ['lookup','contains','probe'])):continue
   need(size>0,'Selected zero-sized symbol');matching=[r for r in nm if r['address']==address and r['size']==size];need(matching,'No raw nm identity')
   elf_matches=[s for s in symbols if s['address']==address and s['size']==size and s['name']in {x['name']for x in matching}];need(elf_matches,'No exact defined ELF FUNC identity')
   targets.append(dict(name=name,address=address,size=size,raw_nm=matching,elf_matches=elf_matches,folded_aliases=[s for s in symbols if s['address']==address]))
  need(required<={t['name']for t in targets},'Missing required native wrappers');need(len(targets)==5,'Expected exactly three wrappers plus two direct public methods')
  for i,t in enumerate(targets):
   begin=t['address'];end=begin+t['size'];label='span-'+str(i)
   text=run(label,'objdump',['-d','--demangle','--no-show-raw-insn','--start-address='+hex(begin),'--stop-address='+hex(end),BINARY]);ins=re.findall(r'^\s*([0-9a-f]+):\s+(\S+)',text,re.M)
   need(ins and int(ins[0][0],16)==begin and all(begin<=int(a,16)<end for a,m in ins),'Wrong/empty ELF bounded span')
   t.update(file=label+'.stdout',begin=begin,end=end,instructions=len(ins),displayed_labels=re.findall(r'^[0-9a-f]+ <(.+)>:',text,re.M));meta['selected'].append(t);persist()
  verify(SOURCE);need(audit()==reuse and sha(BINARY)==DIGEST and require_lease(3)==lease,'Final capture input/lease drift');meta['complete']=True;persist();print('Five ELF-sized spans captured; no BF/build')
 except BaseException as error:meta['error']=repr(error);meta['traceback']=traceback.format_exc();persist();raise
if __name__=='__main__':main()
