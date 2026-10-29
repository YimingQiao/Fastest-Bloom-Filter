"""Capture only missing query callees from the two already-proved ELF files."""
import json
from pathlib import Path
import re
import subprocess
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_guard import HERE, ROOT, sha, verify, recheck
from contract import need
from lease import require

OUT = Path(__file__).resolve().parent / 'callees'
INITIAL = {'normal': {0x2be20, 0x2d790, 0x31400},
           'avx2': {0x285e0, 0x29830, 0x2c6f0}}

def main():
    placement = require()
    need(not OUT.exists(), 'fresh callee output required')
    meta = json.loads((HERE/'validation-v1/metadata.json').read_text())
    need(meta['complete'] and meta['formal_workloads'] == 0, 'bounded proof required')
    prepared = verify(meta['source_commit'])
    for key in ('compiler_consumed_input_sha256', 'tools_sha256', 'all_binary_sha256'):
        recheck(meta[key])
    OUT.mkdir()
    commands = []
    profiles = {}
    for profile in ('normal', 'avx2'):
        asm = meta['assembly'][profile]
        binary = Path(asm['binary'])
        funcs = {}
        for line in (HERE/asm['elf']).read_text().splitlines():
            c = line.split()
            if len(c) >= 8 and c[3] == 'FUNC' and c[6] != 'UND':
                try: start, size = int(c[1], 16), int(c[2], 0)
                except ValueError: continue
                if size: funcs.setdefault(start, []).append((size, c[7]))
        def targets(body, start, size):
            result = []
            for match in re.finditer(r'\b(?:call|jmp)\s+([0-9a-f]+)\s+<([^>]+)>', body):
                target = int(match[1], 16)
                if not start <= target < start+size and '@plt' not in match[2]:
                    need(target in funcs, 'unbound direct query target '+match[1])
                    result.append(target)
            return result
        queue, edges, captures = [], [], []
        known = {s['start'] for s in asm['symbols']}
        for span in asm['symbols']:
            need(sha(HERE/span['stdout']) == span['sha256'], 'original ASM drift')
            if span['role'] == 'Run<': continue
            for target in targets((HERE/span['stdout']).read_text(), span['start'], span['size']):
                edges.append([span['start'], target]); queue.append(target)
        need(set(queue) == INITIAL[profile], 'reviewed initial query tails changed')
        while queue:
            start = queue.pop(0)
            if start in known: continue
            need(len(captures) < 16, 'bounded query closure exceeded')
            aliases = sorted(set(funcs[start])); sizes = {z for z, _ in aliases}
            need(len(sizes) == 1, 'ambiguous ELF FUNC span')
            size = next(iter(sizes))
            label = profile+'-callee-'+str(len(captures))
            out, err = OUT/(label+'.stdout'), OUT/(label+'.stderr')
            argv = ['/usr/bin/objdump', '-d', '--no-show-raw-insn',
                    '--start-address='+str(start), '--stop-address='+str(start+size), str(binary)]
            need(require() == placement, 'lease drift')
            recheck(meta['all_binary_sha256']); recheck(meta['tools_sha256'])
            with out.open('wb') as stdout, err.open('wb') as stderr:
                result = subprocess.run(argv, cwd=ROOT, stdout=stdout, stderr=stderr,
                                        pass_fds=tuple(map(int, placement['fd_evidence'])))
            commands.append(dict(argv=argv, returncode=result.returncode,
                stdout=out.name, stderr=err.name, stdout_sha256=sha(out), stderr_sha256=sha(err)))
            (OUT/'commands.json').write_text(json.dumps(commands, indent=2)+'\n')
            need(result.returncode == 0 and not err.read_bytes(), 'capture failed')
            body = out.read_text()
            pcs = [int(m[1], 16) for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S', body, re.M)]
            need(pcs and pcs[0] == start and all(start <= pc < start+size for pc in pcs),
                 'empty/out-of-span query callee')
            known.add(start)
            for target in targets(body, start, size):
                edges.append([start, target]); queue.append(target)
            captures.append(dict(start=start, size=size, aliases=[s for _, s in aliases],
                stdout=out.name, sha256=sha(out), instruction_count=len(pcs)))
        profiles[profile] = dict(binary=str(binary), binary_sha256=sha(binary),
                                 spans=captures, direct_edges=edges)
    need(verify(meta['source_commit']) == prepared, 'prepared source drift')
    for key in ('compiler_consumed_input_sha256', 'tools_sha256', 'all_binary_sha256'):
        recheck(meta[key])
    result = dict(complete=True, source_commit=meta['source_commit'], profiles=profiles,
        original_metadata_sha256=sha(HERE/'validation-v1/metadata.json'),
        script_sha256=sha(__file__), placement=placement, filter_executions=0, compiler_executions=0)
    (OUT/'CAPTURE.json').write_text(json.dumps(result, indent=2)+'\n')
    print('Captured', sum(len(p['spans']) for p in profiles.values()),
          'same-binary query callees; zero compiler/filter execution.')

if __name__ == '__main__': main()
