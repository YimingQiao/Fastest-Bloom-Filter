#!/usr/bin/env python3
"""Report fixed training winners without selecting replacements from held-out data."""
import argparse
import csv
import io
import json
import math
import statistics
from pathlib import Path

from guards import (HERE,ROOT,command_for,require,sha,validate_cases,verify_confirmation_commit,
                    verify_parent,verify_training)

Z = 1.959963984540054


def wilson_upper(fp, count):
    require(type(fp) is int and type(count) is int and count > 0 and 0 <= fp <= count, 'Invalid calibration sample')
    if fp == count:
        return 1.0
    z2 = Z*Z
    return (fp + z2/2 + Z*math.sqrt(fp*(1-fp/count)+z2/4))/(count+z2)


def analyze(rows, plan, protocol):
    validate_cases(rows,plan,protocol,complete=True)
    by_pair = {(r['configuration_id'],int(r['seed'])): r for r in rows}
    configurations, samples = {}, {}
    for g in plan['configurations']:
        seed_records = []
        for seed in plan['seeds']:
            r = by_pair[(g['configuration_id'],seed)]
            count, fp = int(r['calibration_absent_queries']), int(r['calibration_false_positives'])
            sample = {'seed':seed,'keys':int(r['keys']),'calibration_identity':r['calibration_identity'],
                      'probes':count,'false_positives':fp,'observed_fpr':fp/count,'quality_upper':wilson_upper(fp,count)}
            key = (int(r['keys']),seed,r['calibration_identity'])
            if key in samples:
                require(all(samples[key][k] == v for k,v in sample.items()), 'Shared API calibration sample differs')
            else:
                samples[key] = sample | {'members':[]}
            samples[key]['members'].append(g['configuration_id'])
            timings = {}
            for metric in ('lookup','hash_lookup'):
                raw = metric == 'lookup' and r['input_mode'] == 'raw_bytes'
                timings[metric+'_ns'] = None if raw else float(r[metric+'_ns'])
                timings[metric+'_trials_ns'] = json.loads(r[metric+'_trials_ns'])
            seed_records.append(sample | timings | {'result_checksum':r['result_checksum'],'mixed_false_positives':int(r['false_positives'])})
        configurations[g['configuration_id']] = {'geometry':g,'seeds':seed_records,
                                                'worst_pointwise_quality_upper':max(r['quality_upper'] for r in seed_records)}

    def qualify(cid, cell):
        if cid is None:
            return None
        config = configurations[cid]
        fits = int(config['geometry']['filter_bytes']) <= cell['keys']*cell['memory_cap_bpk']//8
        checks = [{'seed':r['seed'],'quality_upper':r['quality_upper'],'quality_pass':r['quality_upper'] <= cell['fpr_ceiling']} for r in config['seeds']]
        return {'configuration_id':cid,'fits_memory_cap':fits,'worst_pointwise_quality_upper':config['worst_pointwise_quality_upper'],
                'qualified_all_seeds':fits and all(r['quality_pass'] for r in checks),'per_seed_quality':checks}

    def comparison(cell):
        result = dict(cell)
        result['fixed_leader_quality'] = {slot:qualify(cid,cell) for slot,cid in cell['leaders'].items()}
        external_id = cell['leaders']['external']
        pairs = {}
        for slot,cid in cell['leaders'].items():
            if slot == 'external':
                continue
            if cid is None or external_id is None:
                pairs[slot] = {'status':'no_fixed_training_pair','candidate_configuration_id':cid,'external_configuration_id':external_id,'per_seed':[]}
                continue
            per_seed = []
            for candidate, external in zip(configurations[cid]['seeds'],configurations[external_id]['seeds']):
                require(candidate['seed'] == external['seed'], 'Unpaired timing seeds')
                c,e = candidate[cell['metric']],external[cell['metric']]
                ratio = c/e if c is not None and e is not None else None
                quality_pass = candidate['quality_upper'] <= cell['fpr_ceiling'] and external['quality_upper'] <= cell['fpr_ceiling']
                per_seed.append({'seed':candidate['seed'],'candidate_ns':c,'external_ns':e,'candidate_over_external_latency':ratio,
                                 'both_quality_pass':quality_pass,'candidate_quality_upper':candidate['quality_upper'],'external_quality_upper':external['quality_upper'],
                                 'timing_outcome':None if ratio is None else ('loss' if ratio > 1 else 'win' if ratio < 1 else 'tie')})
            ratios = [r['candidate_over_external_latency'] for r in per_seed if r['candidate_over_external_latency'] is not None]
            quality = result['fixed_leader_quality']
            qualified = quality[slot]['qualified_all_seeds'] and quality['external']['qualified_all_seeds']
            pairs[slot] = {'status':'qualified_fixed_pair' if qualified else 'quality_failure_no_replacement',
                           'candidate_configuration_id':cid,'external_configuration_id':external_id,'per_seed':per_seed,
                           'median_candidate_over_external_latency':statistics.median(ratios) if len(ratios)==3 else None,
                           'worst_candidate_over_external_latency':max(ratios) if len(ratios)==3 else None,
                           'timing_losses':sum(r['timing_outcome']=='loss' for r in per_seed),
                           'timing_wins':sum(r['timing_outcome']=='win' for r in per_seed),
                           'interpretation':'Ratios below 1 favor the fixed candidate. If either quality gate fails, timings remain descriptive and do not establish a qualifying win.'}
        result['pairs'] = pairs
        return result

    return {'scope':protocol['scope'],'seeds':plan['seeds'],'measured_rows':len(rows),'selected_configurations':len(configurations),
            'unique_mapping_seed_samples':len(samples),'quality_rule':protocol['quality_rule'],
            'ratio_rule':protocol['aggregation_rule'],'configurations':list(configurations.values()),
            'calibration_samples':list(samples.values()),
            'main_comparisons':[comparison(c) for c in plan['main_comparisons']],
            'frontier_comparisons':[comparison(c) for c in plan['frontier_comparisons']],
            'frontier_records':plan['frontier_records'],'replacement_policy':'Never replace failed or null training leaders from held-out results.'}


def verify_recorded_run(directory, plan, protocol):
    metadata = json.loads((directory/'metadata.json').read_text())
    require(metadata.get('complete') is True and metadata.get('all_frozen_sources_and_binaries_unchanged') is True, 'Run is incomplete or freeze checks failed')
    require(metadata['protocol'] == protocol, 'Recorded protocol changed')
    require(metadata['parent_source_commit'] == protocol['parent_source_commit'], 'Wrong parent source revision')
    require(metadata['selection_sha256'] == sha(HERE/'selection.json'), 'Wrong selection anchor')
    require(metadata['results_sha256'] == sha(directory/'results.csv'), 'Result file changed')
    lease = metadata['lease']
    require(lease['cpu']==3 and lease['lease']=='socket1' and lease['lock_path']==protocol['socket_lock'], 'Wrong measurement lease')
    require(bool(lease['inherited_lock_descriptors']) and all(type(v) is int and v>=0 for v in lease['inherited_lock_descriptors']), 'Missing inherited lock evidence')
    require(len(metadata['cases']) == len(plan['cases']), 'Incomplete recorded cases')
    by_id = {r['configuration_id']:r for r in plan['configurations']}
    recovered, recorded_root = [], None
    for i,(record,case) in enumerate(zip(metadata['cases'],plan['cases'])):
        require(record['case'] == case, 'Recorded case differs from fixed schedule')
        command = record['command']
        require(isinstance(command,list) and len(command)==16 and all(type(v) is str for v in command), 'Malformed recorded command')
        binary = Path(command[3])
        suffix = Path(protocol['binary'])
        require(binary.is_absolute() and binary.parts[-len(suffix.parts):] == suffix.parts, 'Wrong binary command path')
        root = binary.parents[len(suffix.parts)-1]
        require(recorded_root is None or root == recorded_root, 'Inconsistent recorded repository roots')
        recorded_root = root
        require(command == command_for(root,protocol,case), 'Recorded command changed')
        stem = f'case-{i:02d}-{case["case_id"]}'
        stdout, stderr = directory/(stem+'.stdout'),directory/(stem+'.stderr')
        require(sha(stdout)==record['stdout_sha256'] and sha(stderr)==record['stderr_sha256'], 'Raw case artifact changed')
        rows = list(csv.DictReader(io.StringIO(stdout.read_text())))
        require(len(rows)==record['rows']==len(case['filters']), 'Wrong recorded row count')
        expected = {by_id[c]['filter']:by_id[c] for c in case['configuration_ids']}
        for row in rows:
            require(row.get('filter') in expected, 'Unselected raw result')
            g = expected[row['filter']]
            row.update(configuration_id=g['configuration_id'],calibration_identity=g['calibration_identity'])
        recovered.extend(rows)
    with (directory/'results.csv').open() as stream:
        rows = list(csv.DictReader(stream))
    require(rows == recovered, 'Merged results differ from recorded raw stdout')
    require(validate_cases(rows,plan,protocol,complete=True) == metadata['validation'], 'Validation summary changed')
    return rows,metadata


def main():
    require(__debug__, 'Do not run analysis with Python -O')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory',type=Path)
    parser.add_argument('--verify-live',action='store_true',help='Also recheck every dependency and binary in the parent freeze')
    args = parser.parse_args()
    protocol,plan = (json.loads((HERE/f).read_text()) for f in ('protocol.json','selection.json'))
    rows,metadata = verify_recorded_run(args.directory,plan,protocol)
    committed = verify_confirmation_commit(metadata['source_commit'])
    training = verify_training()
    parent = verify_parent(protocol,live=args.verify_live)
    require(metadata['committed_archive'] == committed and metadata['training_archive'] == training, 'Recorded archive verification changed')
    require(metadata['parent_archive'] == parent | {'live_dependency_and_binary_verification':True}, 'Recorded parent verification changed')
    require(metadata['binary_sha256'] == json.loads((HERE/'freeze.json').read_text())['binary_sha256'], 'Wrong recorded executable hash')
    result = analyze(rows,plan,protocol)
    result['provenance'] = {'source_commit':metadata['source_commit'],'parent_source_commit':protocol['parent_source_commit'],
                            'results_sha256':sha(args.directory/'results.csv'),'metadata_sha256':sha(args.directory/'metadata.json'),
                            'analysis_sha256':sha(Path(__file__)),'committed_archive':committed,'parent_archive':parent,'training_archive':training,
                            'training_cpu':2,'confirmation_cpu':3,'cross_run_latency_ratios':False}
    (args.directory/'summary.json').write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
    print(f'Validated {len(rows)} rows; retained all fixed comparisons and per-seed quality/timing outcomes')


if __name__ == '__main__':
    main()
