"""Immutable original54, additive preparation and frozen external/public inputs."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]


def require(ok,message):
    if not ok: raise ValueError(message)


def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()


def blob(path,revision,digest):
    require(re.fullmatch('[0-9a-f]{40}',revision),'Full source revision required')
    data=subprocess.check_output(['git','show',revision+':'+path],cwd=ROOT)
    require(hashlib.sha256(data).hexdigest()==digest and sha(ROOT/path)==digest,'Immutable input differs: '+path)
    return data


def verify(commit=None):
    require(__debug__,'Run without Python -O')
    bindings=json.loads((HERE/'bindings.json').read_text())
    initial=STAGE/'PREPARATION.json'
    data=blob(str(initial.relative_to(ROOT)),bindings['initial_commit'],sha(initial))
    artifacts=json.loads(data)['files']
    require(len(artifacts)==53,'Wrong original preparation cardinality')
    pins={str(initial.relative_to(ROOT)):sha(initial)}
    for name,digest in artifacts.items():
        path=str((STAGE/name).relative_to(ROOT))
        blob(path,bindings['initial_commit'],digest);pins[path]=digest
    for label in ('parent','parity','fixture_source'):
        entry=bindings[label];data=blob(entry['path'],entry['revision'],entry['sha256']);pins[entry['path']]=entry['sha256']
        if label=='parent':parent=json.loads(data)
    require(len(parent['source_sha256'])==195 and len(parent['binary_sha256'])==15,'Wrong frozen serial source/binary set')
    pins.update(parent['source_sha256'])
    pins.update(bindings['extra_sources_sha256'])
    source=(ROOT/bindings['fixture_source']['path']).read_text()
    first=source[source.index('static uint64_t next('):source.index('static size_t index(')]
    fixture=source[source.index('static void fixtures()'):source.index('int main(')].replace('Split64Range f(','Split64RangeNative f(')
    expected='#include "../native-range/split64_bloom.h"\n#include <cstring>\n#include <iostream>\nusing namespace bloom_filters;\n'+first+fixture+'int main() { fixtures(); }\n'
    require((HERE/'native_parity.cpp').read_text()==expected,'Changed12-fixture reproduction')
    prep=HERE/'PREPARATION.json'
    if prep.exists():
        additive=json.loads(prep.read_text())['files']
        for name,digest in additive.items():
            path=str((HERE/name).relative_to(ROOT));pins[path]=digest
        pins[str(prep.relative_to(ROOT))]=sha(prep)
        if commit:
            for name,digest in additive.items():blob(str((HERE/name).relative_to(ROOT)),commit,digest)
            blob(str(prep.relative_to(ROOT)),commit,sha(prep))
    for name,digest in pins.items():require(sha(ROOT/name)==digest,'Changed input: '+name)
    for name,digest in parent['binary_sha256'].items():require(sha(ROOT/name)==digest,'Changed frozen serial executable: '+name)
    return pins,parent['binary_sha256']
