#!/usr/bin/env python3
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse
import pins
def main():
 p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--output',required=True);a=p.parse_args();frozen=pins.verify(a.source_commit)
 from contract import audit
 _,rows=audit(a.output,a.source_commit,frozen);print(f'PASS complete18 commands/{len(rows)} rows, source/tool/binary/raw/quality identities')
if __name__=='__main__':main()
