"""Read-only source binding for the finite calculation; no raw-data loader."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from summarize import build_ledger, need, validate_sources

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def get_sources():
    binding = json.loads((HERE / 'source-binding.json').read_text())
    pinned = {}

    def anchor(commit, path, expected):
        need(bool(re.fullmatch('[0-9a-f]{40}', commit)), 'full immutable source commit required')
        path = Path(path)
        data = subprocess.check_output(['git', 'show', commit + ':' + path.as_posix()], cwd=ROOT)
        need(data == (ROOT / path).read_bytes(), 'live/committed source mismatch: ' + str(path))
        need(hashlib.sha256(data).hexdigest() == expected['sha256'] and len(data) == expected['bytes'],
             'source digest/size mismatch: ' + str(path))
        pinned[path.as_posix()] = expected['sha256']
        return json.loads(data) if path.suffix == '.json' else data

    parent = binding['protocol']
    protocol = anchor(parent['commit'], parent['path'], parent)
    caller = binding['caller']
    preparation = anchor(caller['commit'], caller['path'], caller)
    need(len(preparation['files']) == 35, 'exact caller source closure')
    folder = Path(caller['path']).parent
    for name, item in preparation['files'].items():
        anchor(caller['commit'], folder / name, item)
    selection = json.loads((ROOT / folder / 'selection.json').read_text())
    ledger = json.loads((HERE / 'ledger.json').read_text())
    need(ledger == build_ledger(selection['points']), 'exact committed-selection ledger derivation')
    validate_sources(selection, ledger)
    plan = protocol['conditional_timing_proposal']
    need(plan['seeds'] == [982451653, 961748941] and plan['batches'] == [1, 31, 4096] and
         plan['counts']['processes'] == 24 and plan['counts']['rows'] == 216 and
         plan['primary_cap_bpk'] == 16 and plan['primary_fpr_ceiling'] == .01,
         'frozen parent protocol mismatch')
    return selection, ledger, pinned


if __name__ == '__main__':
    selection, ledger, pinned = get_sources()
    print(f'PASS {len(pinned)} committed source blobs; {len(selection["points"])} points; '
          f'{len(ledger)} cases; 216 rows; no measured-data loader')
