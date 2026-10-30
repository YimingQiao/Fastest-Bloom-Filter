"""Materialize fixed workload/order arithmetic only; never construct a filter."""
import hashlib
import itertools
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
MASK = (1 << 64) - 1

def first_mix(seed):
    z = (seed + 0x9e3779b97f4a7c15) & MASK
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & MASK
    return z ^ (z >> 31)

def derive():
    protocol = json.loads((HERE / 'protocol.json').read_text())
    q = 1 << protocol['query_power']
    original = []
    for profile, power, seed, case in itertools.product(protocol['profiles'], protocol['key_powers'], protocol['seeds'], protocol['cases']):
        n = 1 << power
        base = first_mix(seed) % ((1 << 32) - n - q)
        hits = q // 100 * case['hit'] + min(q % 100, case['hit'])
        original.append(dict(profile=profile['name'], key_power=power, keys=n, queries=q,
                             seed=seed, **case, filter_bytes=n * 3, physical_lines=n * 3 // 64,
                             raw_counter_envelope=[base, base + n + q], present_queries=hits,
                             source_rng_draws=1 + hits,
                             metrics=protocol['metrics_four'] if case['batch'] == 1 else protocol['metrics_two']))
    ledger = []
    for round_number, rows in [(1, original), (2, list(reversed(original)))]:
        for row in rows:
            ledger.append(dict(case_index=len(ledger), round=round_number, **row,
                               api_order=protocol['arms'] if round_number == 1 else list(reversed(protocol['arms']))))
    assert len(ledger) == 96 and sum(len(row['metrics']) for row in ledger) == 288
    envelopes = sorted({tuple(r['raw_counter_envelope']) for r in ledger})
    assert len(envelopes) == 4
    assert all(a[1] <= b[0] for a, b in zip(envelopes, envelopes[1:]))
    # Fixed previously executed tiny proof is not a formal observation.
    old_base = first_mix(74381) % ((1 << 32) - 256 - 4096)
    assert all(end <= old_base or old_base + 256 + 4096 <= begin for begin, end in envelopes)
    return dict(schema=1, workload_rule='Original caller counter/hash/mix construction with only n,q,seed parameterized.',
                envelopes_are_source_derived_not_emitted_digests=True,
                disjoint_formal_envelopes=envelopes, tiny_proof_envelope=[old_base, old_base + 256 + 4096],
                cases=ledger)

if __name__ == '__main__':
    value = derive()
    (HERE / 'ledger.json').write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')
    print(json.dumps(dict(processes=len(value['cases']), rows=2 * len(value['cases']),
                          ledger_sha256=hashlib.sha256((HERE / 'ledger.json').read_bytes()).hexdigest())))
