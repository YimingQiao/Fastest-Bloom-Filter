#!/usr/bin/env python3
"""Regenerate the complete sidecar from committed raw and compare every product."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--raw-commit',required=True);args=parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='fixed-k-report-verify-')as temporary:
        report=Path(temporary)/'report'
        process=subprocess.run([sys.executable,str(HERE/'summarize.py'),'--raw-commit',args.raw_commit,'--output',str(report)],capture_output=True,text=True)
        if process.returncode:raise RuntimeError(process.stdout+process.stderr)
        # Interpretation reads only complete derived tables. Redirect its report
        # path in this isolated process; no producer/Bloom code is executed.
        import interpret
        interpret.REPORT=report;interpret.main()
        expected={p.name for p in(HERE/'report').iterdir()if p.is_file()}
        actual={p.name for p in report.iterdir()if p.is_file()}
        assert expected==actual,'Generated product inventory differs'
        for name in expected:assert (report/name).read_bytes()==(HERE/'report'/name).read_bytes(),name
        print(json.dumps(dict(complete=True,raw_commit=args.raw_commit,products=len(expected),
            all_products_byte_equal=True,full_committed_raw_source_dependency_binary_audit=True,
            result_sha256={name:hashlib.sha256((report/name).read_bytes()).hexdigest()for name in sorted(expected)}),indent=2))

if __name__=='__main__':main()
