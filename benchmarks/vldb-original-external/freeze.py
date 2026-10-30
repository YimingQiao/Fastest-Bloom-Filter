#!/usr/bin/env python3
"""Archive completed public-API proofs; never runs or times a filter."""
import hashlib
import json
from pathlib import Path
from verify_sources import verify

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGES = {
    'native': 'validation-v4-gcc-process',
    'native_asan_ubsan': 'validation-v5-gcc-native-asan',
    'avx2': 'validation-v7-gcc-avx2',
}


def need(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text())


def macros(path):
    values = {}
    for line in path.read_text().splitlines():
        words = line.split(maxsplit=2)
        if len(words) >= 2 and words[0] == '#define':
            values[words[1]] = words[2] if len(words) == 3 else ''
    return values


def files():
    result = []
    for path in HERE.rglob('*'):
        if not path.is_file():
            continue
        rel = path.relative_to(HERE)
        if any(p in ('.deps', '__pycache__', 'binaries') for p in rel.parts):
            continue
        if str(rel) == 'compatibility-v2/names' or path.name in ('FREEZE.json', 'manifest.json'):
            continue
        with path.open('rb') as stream:
            need(stream.read(4) != b'\x7fELF', 'Unexpected executable in source inventory: ' + str(rel))
        result.append(path)
    return sorted(result)


def main():
    need(__debug__, 'Run without Python -O')
    need(not (HERE/'FREEZE.json').exists() and not (HERE/'manifest.json').exists(), 'Refuse archive overwrite')
    pinned = verify()
    reference = None
    observed, binaries, consumed = {}, {}, {}
    accounting = {}
    for label, name in STAGES.items():
        directory = HERE/name
        metadata = read(directory/'metadata.json')
        need(metadata['complete'] and metadata['all_sources_unchanged'], 'Incomplete proof: ' + name)
        need(metadata['tuner_file_before'] == metadata['tuner_file_after'], 'Tuner file changed')
        need(metadata['tuner_file_before']['exists'] is False, 'This archive is the absent-tuner-file fixture')
        need(metadata['lease']['cpu'] == 2 and metadata['lease']['lease'] == 'socket0'
             and metadata['lease']['inherited_lock_descriptors'], 'Wrong proof lease')
        need(len(metadata['checksum_output']) == 8, 'Missing fresh-process correctness case')
        if reference is None:
            reference = metadata['checksum_output']
        need(metadata['checksum_output'] == reference, 'Backend output-digest mismatch')
        for relative, digest in metadata['source_sha256'].items():
            need(sha(directory/'source-snapshot'/relative) == digest, 'Historical source snapshot changed')
            if Path(relative).suffix in ('.cpp', '.h', '.hpp'):
                need(sha(ROOT/relative) == digest, 'Current compiled source differs from passed stage: ' + relative)
        for path, digest in metadata['binary_sha256'].items():
            need(sha(Path(path)) == digest, 'Passed executable changed')
            copies = list((directory/'binaries').rglob(Path(path).name))
            need(len(copies) == 1 and sha(copies[0]) == digest, 'Retained executable copy changed')
            binaries[path] = digest
            binaries[str(copies[0])] = digest
        tag = 'native-asan' if label == 'native_asan_ubsan' else label
        header_data = read(directory/(tag+'-consumed-headers.json'))
        need(header_data['boost']['version'] == '1_83', 'Unexpected Boost version')
        for path, digest in header_data['consumed_files'].items():
            need(sha(Path(path)) == digest, 'Consumed compiler input changed: ' + path)
            need(path not in consumed or consumed[path] == digest, 'Conflicting compiler input versions')
            consumed[path] = digest
        defines = macros(directory/(tag+'-macros.stdout'))
        need(defines.get('__AVX2__') == '1', 'Missing expected AVX2 backend')
        if label == 'avx2':
            need(not any(k.startswith('__AVX512') for k in defines), 'AVX512 leaked into AVX2 proof')
        else:
            need(defines.get('__AVX512F__') == '1', 'Native archive did not exercise AVX512')
        need((defines.get('__SANITIZE_ADDRESS__') == '1') == (label == 'native_asan_ubsan'), 'Wrong sanitizer boundary')
        if label == 'native_asan_ubsan':
            commands = header_data['compile_commands']
            need(all('-fsanitize=address,undefined' in r['command'] and '-fno-sanitize-recover=all' in r['command'] for r in commands), 'Sanitizer flags changed')
            need(all(not p.read_text() for p in directory.glob('*-check-*.stderr')), 'Sanitizer diagnostic emitted')
        else:
            rows = read(directory/(tag+'-accounting.json'))
            need(len(rows) == 9, 'Missing allocation rows')
            accounting[label] = rows
        observed[label] = dict(metadata_sha256=sha(directory/'metadata.json'),
                               consumed_header_record_sha256=sha(directory/(tag+'-consumed-headers.json')),
                               boost_header_count=len(header_data['boost']['consumed_headers']),
                               total_consumed_files=len(header_data['consumed_files']),
                               macro_record_sha256=sha(directory/(tag+'-macros.stdout')),
                               complete=True)
    need(accounting['native'] == accounting['avx2'], 'Backend allocation accounting differs; investigate before freezing')
    failures = {
        'validation-v1': 'Unchanged upstream std::function restrict spelling rejected by Clang23',
        'validation-v2-gcc': 'Intentional compiler stop before adding unchanged upstream extern declarations',
        'validation-v3-gcc-extern': 'Guard caught non-overwriting upstream tuner; corrected by fresh processes',
        'validation-v6-gcc-portable': 'Unchanged non-AVX library fails at missing emulated storeu specialization',
    }
    for name in failures:
        need(read(HERE/name/'metadata.json')['complete'] is False, 'Failure-stage status changed')
    for name, digest in read(HERE/'validation-v3-gcc-extern/built-binaries.json').items():
        path = HERE/'validation-v3-gcc-extern/binaries'/name
        need(sha(path) == digest, 'Rejected V3 executable changed')
        binaries[str(path)] = digest
    frozen = dict(scope='Public API correctness and requested-allocation proof only; no throughput or FPR ranking',
                  upstream_unchanged=pinned, passed_stages=observed, retained_failed_stages=failures,
                  queried_layouts='32/64-bit W8/S8/K8 U1/2/4; 64-bit W1/S1/K8 U0; 32768 bits; positive K',
                  input_contract='Unique raw u32; native controls widen and common-hash inside their API',
                  process_contract='Fresh process per U; exact metadata and lifetime guards; existing HOME untouched',
                  accounting_scope='Requested C++ heap plus directly wrapped mmap; allocator usable size/RSS/libc internal malloc excluded',
                  checksum_output=reference, consumed_compiler_inputs_sha256=consumed, binary_sha256=binaries)
    (HERE/'FREEZE.json').write_text(json.dumps(frozen, indent=2)+'\n')
    inventory = {str(p.relative_to(HERE)): sha(p) for p in files()}
    inventory['FREEZE.json'] = sha(HERE/'FREEZE.json')
    (HERE/'manifest.json').write_text(json.dumps(dict(scope=frozen['scope'], files=inventory), indent=2)+'\n')
    print(json.dumps(dict(files=len(inventory), compiler_inputs=len(consumed), binaries=len(binaries),
                          freeze_sha256=sha(HERE/'FREEZE.json'), manifest_sha256=sha(HERE/'manifest.json')), indent=2))


if __name__ == '__main__':
    main()
