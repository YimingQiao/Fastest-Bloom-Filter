"""Seven small validator edits; all phase/trial/geometry checks retained."""
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
COMMIT='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2'
PARENT='experiments/2026-10-29-four-sector-range12-rust-screen/caller/preflight/guard.py'
def generate():
    s=subprocess.check_output(['git','show',COMMIT+':'+PARENT],cwd=ROOT,text=True)
    edits=[('NAMES = NATIVE | EXTERNAL | {RANGE, K12}',"CANDIDATE = 'FourSectorRange12InlineV1'\nNAMES = NATIVE | EXTERNAL | {RANGE, K12, CANDIDATE}"),
      ('len(names) == len(set(names)) == 21','len(names) == len(set(names)) == 22'),
      ('if name == K12:', 'if name in {K12, CANDIDATE}:'),
      ("kind, probes, owner = 'top24_range_lines', 12, 'K12_experiment'", "kind, probes, owner = 'top24_range_lines', 12, 'K12_inline_experiment' if name == CANDIDATE else 'K12_experiment'"),
      ("calibration_absent_queries=1 << protocol['calibration_power']", "calibration_absent_queries=(1 << protocol['calibration_power']) if protocol['calibration_power'] else 0"),
      ("0 <= int(row['calibration_false_positives']) <= 1 << protocol['calibration_power']", "0 <= int(row['calibration_false_positives']) <= ((1 << protocol['calibration_power']) if protocol['calibration_power'] else 0)")]
    for old,new in edits:
        if s.count(old)!=1:raise ValueError('Validator anchor drift '+old)
        s=s.replace(old,new,1)
    return s
if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();out=HERE/'guard.py';text=generate()
    if a.write:out.write_text(text)
    elif out.read_text()!=text:raise ValueError('Derived guard drift')
    print('Exact six-edit row guard verified')
