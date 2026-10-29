#!/usr/bin/env python3
import argparse,json
from screen_guard import HERE,verify,audit
p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);a=p.parse_args()
binary,_=verify(a.source_commit);output=HERE/'results-v1'
rows=audit(output,json.loads((output/'metadata.json').read_text()),binary,a.source_commit)
print('PASS',len(rows),'complete fixed rows; no ranking performed')
