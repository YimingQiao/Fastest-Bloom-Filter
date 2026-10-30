#!/usr/bin/env python3
"""Read-only disassembly comparison of the frozen Byte lookup functions."""
import hashlib,json,pathlib,re,subprocess
HERE=pathlib.Path(__file__).resolve().parent
BIN=pathlib.Path('/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark')
EXPECTED='0caf0d3ff982ffdc295b6bb7010ae148bd5ffa240426573429e2ae2e92036926'
assert hashlib.sha256(BIN.read_bytes()).hexdigest()==EXPECTED
starts={'original':0x629d0,'candidate':0x65fb0};size=0x1f4
rows={}
for name,start in starts.items():
 text=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={start+size}',str(BIN)],text=True)
 (HERE/f'{name}.asm').write_text(text)
 out=[]
 for line in text.splitlines():
  m=re.match(r'\s*([0-9a-f]+):\s+(.*)',line)
  if not m:continue
  pc=int(m[1],16); asm=m[2]; off=pc-start
  # The active n=3 AVX2 route includes entry before the n=1 body, the
  # AVX2 block, and the shared epilogue; excludes scalar/panic blocks.
  active=off<0x33 or 0x85<=off<0x166 or 0x19f<=off<0x1ae
  if not active:continue
  ref=re.search(r'#\s+([0-9a-f]+)',asm)
  asm=asm.split('#',1)[0].rstrip()
  asm=re.sub(r'\s+<.*','',asm)
  if '(%rip)' in asm:
   assert ref
   asm=re.sub(r'-?0x[0-9a-f]+\(%rip\)',f'RIP_TARGET_0x{int(ref[1],16):x}',asm)
  m=re.match(r'(j\w+)\s+([0-9a-f]+)$',asm)
  if m:
   target=int(m[2],16);assert start<=target<start+size
   asm=f'{m[1]} LOCAL_0x{target-start:x}'
  out.append((off,asm))
 rows[name]=out
 (HERE/f'{name}-active.normalized.txt').write_text('\n'.join(f'{off:03x}: {asm}' for off,asm in out)+'\n')
assert rows['original']==rows['candidate']
wrapper=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn','--start-address=0x223e0','--stop-address=0x22420',str(BIN)],text=True)
(HERE/'batch-wrapper.asm').write_text(wrapper)
relocations=subprocess.check_output(['readelf','-rW',str(BIN)],text=True)
selected=[line for line in relocations.splitlines() if line.startswith(('00000000000aa010 ', '00000000000aa028 '))]
assert len(selected)==2 and selected[0].endswith('65fb0') and selected[1].endswith('629d0')
(HERE/'wrapper-relocations.txt').write_text('\n'.join(selected)+'\n')
summary={'binary':str(BIN),'binary_sha256':EXPECTED,'function_size_bytes':size,'original_start':hex(starts['original']),'candidate_start':hex(starts['candidate']),'active_n3_avx2_instruction_count':len(rows['original']),'active_n3_avx2_normalized_equal':True,'normalization':'PC-relative displacements resolved to exact constant addresses; intrafunction branches expressed as local offsets; no register/opcode/ordinary operand normalization','original_loop_address':'0x62a90','candidate_loop_address':'0x66070','original_loop_mod64':16,'candidate_loop_mod64':48,'wrapper_size_bytes':6,'wrapper_shape':'One indirect tail jump for both monomorphized lookup wrappers; distinct GOT entries','scope':'Post-screen read-only audit, not new timing; scalar fallbacks and cold panic text excluded from active AVX2 equality'}
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary))
