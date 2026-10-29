"""Extract address maps from retained text only; manual findings are in REVIEW.md."""
import json
from pathlib import Path
import re
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_guard import HERE, sha
from contract import need

def main():
    meta=json.loads((HERE/'validation-v1/metadata.json').read_text())
    clocks=[]
    for profile,asm in meta['assembly'].items():
        for span in asm['symbols']:
            if span['role']!='Run<': continue
            body=(HERE/span['stdout']).read_text()
            calls=[(int(m[1],16),int(m[2],16),m[3]) for m in re.finditer(
                r'^\s*([0-9a-f]+):\s+call\s+([0-9a-f]+)\s+<([^>]+)>',body,re.M)]
            timer=[a for a,_,label in calls if 'steady_clock3now' in label]
            need(len(timer)==2,'exact clock pair')
            queries=[dict(pc=a,target=t,label=label) for a,t,label in calls
                if timer[0]<a<timer[1] and ('lookup_kernel' in label or 'inline_single_kernel' in label)]
            need(len(queries)==4,'four timed contract branches')
            checks=[a for a,_,label in calls if a>timer[1] and 'Output5Check' in label]
            need(checks,'full-output validation after stop')
            clocks.append(dict(profile=profile,type=span['display_label'],run_start=span['start'],
                run_size=span['size'],source_span=span['stdout'],source_sha256=span['sha256'],
                start_clock=timer[0],stop_clock=timer[1],queries=queries,first_output_check=checks[0]))
    need(len(clocks)==18,'nine typed clocks per profile')
    result=dict(complete=True,manual_review='passed',source_commit=meta['source_commit'],
        binary_sha256={p:a['sha256'] for p,a in meta['assembly'].items()},clocks=clocks,
        review_scope='Actual native/AVX2 query routing and clock boundaries; no speed inference.',
        peers=['root: pipeline, short-call frames and candidate clocks',
               'baseline_survey: native/AVX2 pipeline and both candidate/control clocks',
               'external_cpp: all typed clock maps and recursive direct query target closure'],
        original_manual_pending_preserved=True,
        callee_capture_sha256=sha(HERE/'assembly-review/callees/CAPTURE.json'))
    (HERE/'assembly-review/REVIEW.json').write_text(json.dumps(result,indent=2)+'\n')
    print('18 typed clock maps extracted from existing spans; no binary execution or disassembly.')

if __name__=='__main__':main()
