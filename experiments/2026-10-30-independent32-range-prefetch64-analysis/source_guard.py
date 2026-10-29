"""Read-only immutable source binding; no raw-data loader or caller execution."""
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
    need(binding['complete'] is True, 'immutable caller binding is pending')
    pinned = {}

    def anchor(commit, path, expected):
        need(type(commit) is str and bool(re.fullmatch('[0-9a-f]{40}', commit)),
             'full immutable source commit required')
        path = Path(path)
        actual = ROOT / path
        need(not path.is_absolute() and not actual.is_symlink() and
             actual.resolve().is_relative_to(ROOT.resolve()), 'escaped source path')
        data = subprocess.check_output(['git', 'show', commit + ':' + path.as_posix()], cwd=ROOT)
        need(data == actual.read_bytes(), 'live/committed source mismatch: ' + str(path))
        need(hashlib.sha256(data).hexdigest() == expected['sha256'] and len(data) == expected['bytes'],
             'source digest/size mismatch: ' + str(path))
        pinned[path.as_posix()] = expected['sha256']
        return json.loads(data) if path.suffix == '.json' else data

    protocol = anchor(binding['protocol']['commit'], binding['protocol']['path'], binding['protocol'])
    selection = anchor(binding['selection']['commit'], binding['selection']['path'], binding['selection'])
    caller = binding['caller']
    preparation = anchor(caller['commit'], caller['path'], caller)
    need(len(preparation['files']) == caller['files'], 'exact caller source closure')
    folder = Path(caller['path']).parent
    for name, item in preparation['files'].items():
        need(not Path(name).is_absolute() and (ROOT / folder / name).resolve().is_relative_to((ROOT / folder).resolve()),
             'escaped caller inventory member')
        anchor(caller['commit'], folder / name, item)
    need('selection.json' in preparation['files'], 'caller selection absent from source inventory')
    caller_selection = json.loads((ROOT / folder / 'selection.json').read_text())
    need(caller_selection['points'] == selection['points'], 'caller/core formal point identities differ')
    ledger_bytes = (HERE / 'ledger.json').read_bytes()
    need(hashlib.sha256(ledger_bytes).hexdigest() == binding['expected_ledger_sha256'], 'predeclared ledger changed')
    ledger = json.loads(ledger_bytes)
    need(ledger == build_ledger(selection['points']), 'exact committed-selection ledger derivation')
    validate_sources(selection, ledger)
    formal, quality = protocol['formal'], protocol['quality']
    need(formal['seeds'] == [982451653, 961748941] and formal['batches'] == [1, 31, 4096] and
         formal['key_powers'] == [16, 25] and formal['query_power'] == 22 and formal['hit'] == 50 and
         formal['repeats'] == 8 and formal['rounds'] == [1, 2] and
         formal['point_count'] == 16 and formal['processes'] == 24 and formal['rows'] == 192 and
         formal['vectors'] == 512 and formal['samples'] == 4096 and formal['budget_cap_bpk'] == 16 and
         quality['calibration_power'] == 26 and quality['api_records'] == 32 and
         quality['known_mapping_groups'] == 26 and quality['reuse_rows'] == 160 and
         quality['pooling'] is False and quality['gate'] == 'both-seed pointwise two-sided95% Wilson upper<=0.01' and
         protocol['analysis']['primary_comparisons'] == 24,
         'frozen protocol mismatch')
    return selection, ledger, pinned

if __name__ == '__main__':
    selection, ledger, pinned = get_sources()
    print(f'PASS {len(pinned)} committed source blobs; {len(selection["points"])} points; '
          f'{len(ledger)} cases; 192 rows; no measured-data loader')

