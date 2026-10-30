"""Resolve Cargo dep-info by structured package/manifest/artifact identity."""
import hashlib,json,re,shlex
from pathlib import Path

def need(ok,text):
    if not ok:raise ValueError(text)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def cargo_roots(texts,target):
    roots={}
    for text in texts:
        for line in text.splitlines():
            value=json.loads(line)
            if value.get('reason')!='compiler-artifact':continue
            manifest=Path(value['manifest_path']).resolve();source=Path(value['target']['src_path']).resolve()
            need(source.is_relative_to(manifest.parent),'Cargo source outside its package')
            package=value['package_id']
            need(package.startswith('path+file://'+str(manifest.parent)+'#'),'Cargo package/manifest disagreement')
            for name in value['filenames']:
                artifact=Path(name).resolve();need(artifact.is_relative_to(target),'Cargo artifact outside target')
                # The executable dep-info path is exact. Rust library objects
                # retain the same hash stem but omit the leading `lib`.
                candidates=[artifact.with_suffix('.d')]
                if artifact.name.startswith('lib') and artifact.suffix in ('.rlib','.rmeta'):
                    candidates.append(artifact.with_name(artifact.name[3:]).with_suffix('.d'))
                identity={'manifest':str(manifest),'package_id':package,'source':str(source)}
                for d in candidates:
                    key=str(d)
                    need(key not in roots or roots[key]==identity,'Ambiguous Cargo dep-info owner')
                    roots[key]=identity
                if value['target'].get('kind')==['bin'] and artifact.name==value['target']['name']:
                    key='bin-stem:'+value['target']['name']
                    need(key not in roots or roots[key]==identity,'Ambiguous Cargo binary stem')
                    roots[key]=identity
                    package_name=package.split('#',1)[1].rsplit('@',1)[0]
                    key='nightly-bin:'+package_name+':'+value['target']['name']
                    record={'identity':identity,'reported_artifact':str(artifact)}
                    need(key not in roots or roots[key]==record,'Ambiguous nightly Cargo binary package')
                    roots[key]=record
    return roots

def owner_for(dep,owners):
    exact=owners.get(str(dep.resolve()))
    if exact is not None:return exact
    # Cargo reports the final un-hashed executable, while rustc's dep-info
    # uses target_name-<16-hex-disambiguator>.d. Require one structured bin
    # target identity for that exact stem; never choose by source-file existence.
    candidates=[identity for key,identity in owners.items() if key.startswith('bin-stem:')
        and re.fullmatch(re.escape(key[len('bin-stem:'):])+r'-[0-9a-f]{16}\.d',dep.name)]
    need(len(candidates)<=1,'Ambiguous Cargo hashed binary owner')
    if candidates:return candidates[0]
    # Nightly Cargo's final bin is a hard link/copy of build/package/hash/out/bin.
    # Match all structural fields to the unique structured Cargo package and
    # target; prove that actual sibling executable is byte-identical to the
    # reported final artifact. This is not a first-existing-path fallback.
    matches=[]
    for key,record in owners.items():
        if not key.startswith('nightly-bin:'):continue
        package,target_name=key[len('nightly-bin:'):].split(':',1)
        reported=Path(record['reported_artifact'])
        if (dep.name==target_name+'.d' and dep.parent.name=='out'
            and re.fullmatch('[0-9a-f]{16}',dep.parent.parent.name)
            and dep.parent.parent.parent.name==package
            and dep.parent.parent.parent.parent==reported.parent/'build'):
            sibling=dep.with_suffix('')
            need(sibling.is_file()and reported.is_file(),'Missing nightly actual/final executable')
            digest=sha(reported);need(sha(sibling)==digest,'Nightly actual/final executable differ')
            identity=dict(record['identity'])
            identity['nightly_artifact_alias']={'actual_executable':str(sibling),'reported_executable':str(reported),'sha256':digest}
            matches.append(identity)
    need(len(matches)<=1,'Ambiguous nightly binary provenance')
    return matches[0] if matches else None

def collect(build,target,cargo_texts,repo_sources,root):
    build=Path(build).resolve();target=Path(target).resolve();root=Path(root).resolve()
    owners=cargo_roots(cargo_texts,target);consumed={};rules=[]
    dependencies=sorted(list(build.rglob('*.o.d'))+list(target.rglob('*.d')))
    need(dependencies,'Actual dependency files missing')
    for dep in dependencies:
        text=dep.read_text();first=text.replace('\\\n',' ').splitlines()[0]
        need(': 'in first,'Malformed dependency rule')
        tokens=shlex.split(first.split(': ',1)[1]);relative=[t for t in tokens if not Path(t).is_absolute()]
        owner=None
        if relative and dep.is_relative_to(target):
            lhs=shlex.split(first.split(': ',1)[0])
            need(lhs==[str(dep)],'Relative Cargo rule LHS is not its actual dep-info artifact')
            owner=owner_for(dep,owners)
            need(owner is not None,'No unique Cargo artifact owner for relative dep-info '+str(dep))
            base=Path(owner['manifest']).parent
            need(Path(owner['source']) in [(base/t).resolve() for t in tokens],'Cargo target source absent from its dep-info')
        else:base=root
        resolved=[]
        for token in tokens:
            source=Path(token);source=(base/source).resolve()if not source.is_absolute()else source.resolve()
            need(source.is_file(),'Missing actual compiler input: '+str(source))
            digest=sha(source)
            if source.is_relative_to(root):need(repo_sources.get(str(source.relative_to(root)))==digest,'Unfrozen repository compiler input '+str(source))
            consumed[str(source)]=digest;resolved.append(str(source))
        rules.append({'path':str(dep),'sha256':sha(dep),'owner':owner,'resolved_inputs':resolved,'text':text})
    return consumed,rules
