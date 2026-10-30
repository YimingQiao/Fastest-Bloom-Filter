#!/usr/bin/env python3
"""Derive unchanged raw8 clocks/control bodies plus explicit natural Poppy APIs."""
import argparse
import difflib
import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = 'experiments/2026-10-29-fastbloom-rs-raw8-caller'
SOURCE = 'd23791243dabdda85a8ff2eb11ce2d9b3e5a6b47'
SELECTION = '29242c0263cde19c9cc4bf0af761808431fa6163'
UNION = 'experiments/2026-10-29-poppy-raw-public-bridge-selection/selection-v2/union.json'


def blob(commit, path):
    return subprocess.check_output(['git', 'show', commit+':'+path], cwd=ROOT)


def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new)


def points():
    values = json.loads(blob(SELECTION, UNION))
    assert len(values) == 14 and sum(p['keys'] == 65536 for p in values) == 7
    return sorted(values, key=lambda p: int(p['filter'].removeprefix('PoppyPublic')))


def geometry(values):
    head = '''//! Exact constructors from the completed historical14 union; no future quality claim.
pub struct Point {
    pub id: usize, pub byte_name: &'static str, pub typed_name: &'static str,
    pub configuration: &'static str, pub n: usize, pub budget_bpk: u32,
    pub fpp_bits: u64, pub policy: poppy_filters::OptLevel, pub policy_name: &'static str,
    pub bucket_bytes: usize, pub cache_bytes: usize, pub probes: i32,
}
impl Point {
    pub fn check(&self, n: usize, bpk: u32) -> crate::geometry::Result<()> {
        if n != self.n || bpk != self.budget_bpk {
            return Err("Poppy requires its frozen real n and declared budget".into());
        }
        Ok(())
    }
    pub fn plan(&self, n: usize, bpk: u32) -> crate::geometry::Result<crate::geometry::Geometry> {
        self.check(n, bpk)?;
        let budget_bytes = crate::geometry::bytes(n, bpk)?;
        let allocated_bytes = self.bucket_bytes.checked_add(self.cache_bytes).ok_or("backing overflow")?;
        if allocated_bytes > budget_bytes { return Err("Poppy exceeds actual-byte cap".into()); }
        Ok(crate::geometry::Geometry { budget_bytes, allocated_bytes, logical_bytes: self.bucket_bytes,
            unit_bytes: 4096, effective_probes: self.probes, kind: "poppy_public_buckets_with_cache",
            probe_policy: "frozen_public_params", constructor_argument: self.n, origin: "external_poppy_natural" })
    }
}
pub const POINTS: &[Point] = &[
'''
    lines = []
    for p in values:
        c = p['canonical_constructor'];i = int(p['filter'].removeprefix('PoppyPublic'))
        assert p['cache_bytes'] == c['cache_bytes'] and p['actual_bytes'] == p['bucket_bytes']+p['cache_bytes']
        policy = {'none': 'None', 'space': 'Space', 'speed': 'Speed', 'best': 'Best'}[c['policy']]
        lines.append(f'    Point {{ id: {i}, byte_name: "PoppyRawByte{i:03d}", typed_name: "PoppyRawTyped{i:03d}", configuration: "{p["configuration_id"]}", n: {p["keys"]}, budget_bpk: {p["run_budget_bpk"]}, fpp_bits: 0x{c["fpp_bits"]}, policy: poppy_filters::OptLevel::{policy}, policy_name: "{c["policy"]}", bucket_bytes: {p["bucket_bytes"]}, cache_bytes: {p["cache_bytes"]}, probes: {c["probes"]} }},\n')
    tail = '''];
pub fn by_id(id: usize) -> &'static Point {
    POINTS.iter().find(|p| p.id == id).expect("frozen Poppy constructor ID")
}
pub fn by_name(name: &str) -> Option<(&'static Point, bool)> {
    POINTS.iter().find_map(|p| if name == p.byte_name { Some((p, false)) }
        else if name == p.typed_name { Some((p, true)) } else { None })
}
pub fn metadata_csv(name: &str) -> String {
    if let Some((p, _)) = by_name(name) {
        format!("{},{:016x},{},{},{}", p.policy_name, p.fpp_bits, p.bucket_bytes, p.cache_bytes, p.configuration)
    } else { ",,,,".to_string() }
}
'''
    return (head+''.join(lines)+tail).encode()


def expected():
    values = points();outputs = {};recipes = {}
    names = subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', SOURCE, PARENT+'/benchmark'], cwd=ROOT, text=True).splitlines()
    for name in names:
        relative = name.removeprefix(PARENT+'/')
        raw = blob(SOURCE, name)
        if relative == 'benchmark/Cargo.lock':
            outputs['dependency-preparation/parent-raw8-Cargo.lock'] = raw
            continue
        text = raw.decode()
        if relative == 'benchmark/Cargo.toml':
            text = text.replace('fastest-bloom-filter-raw8-public-caller', 'fastest-bloom-filter-poppy-natural-raw-caller').replace('name = "raw8_benchmark"', 'name = "poppy_raw_benchmark"')
            text = text.replace('path = "../native"', 'path = "../../2026-10-29-fastbloom-rs-raw8-caller/native"')
            text = text.replace('path = "../upstream/fastbloom-rs"', 'path = "../../2026-10-29-fastbloom-rs-raw8-caller/upstream/fastbloom-rs"')
            text = replace_once(text, '[dependencies]\n', '[dependencies]\npoppy-filters = { path = "../../../build/poppy-source/poppy" }\n')
        elif relative == 'benchmark/src/main.rs':
            text = replace_once(text, 'mod reporter;\n', 'mod reporter;\nmod poppy_raw;\nmod poppy_geometry;\nuse poppy_raw::PoppyRaw;\n')
            new_names = ''.join(f'    "PoppyRaw{form}{int(p["filter"].removeprefix("PoppyPublic")):03d}",\n' for p in values for form in ('Byte', 'Typed'))
            text = replace_once(text, '    "FastbloomRsRawK24",\n];', '    "FastbloomRsRawK24",\n'+new_names+'];')
            old = '''    let mut jobs = filter_selection::select_filters(
        args.get(8).map(String::as_str).unwrap_or(""),
        FILTER_NAMES,
    )'''
            new = '''    let selection = args.get(8).map(String::as_str).unwrap_or("");
    // Preserve the frozen45 default; natural Poppy constructors require an explicit selection.
    let available = if selection.is_empty() { &FILTER_NAMES[..45] } else { FILTER_NAMES };
    let mut jobs = filter_selection::select_filters(selection, available)'''
            text = replace_once(text, old, new)
            arms = ''.join(f'            "PoppyRaw{form}{int(p["filter"].removeprefix("PoppyPublic")):03d}" => report::<PoppyRaw<{int(p["filter"].removeprefix("PoppyPublic"))}, {str(form == "Typed").lower()}>>(name, &inserted, &query, &c),\n' for p in values for form in ('Byte', 'Typed'))
            text = replace_once(text, '            _ => unreachable!(),\n', arms+'            _ => unreachable!(),\n')
            text += '\n#[cfg(test)]\nmod poppy_tests;\n'
        elif relative == 'benchmark/src/geometry.rs':
            text = replace_once(text, '    let budget = bytes(n, bpk)?;\n    let mut g = Geometry', '    if let Some((point, _)) = crate::poppy_geometry::by_name(name) { return point.plan(n, bpk); }\n    let budget = bytes(n, bpk)?;\n    let mut g = Geometry')
        elif relative == 'benchmark/src/report.rs':
            text = replace_once(text, 'implementation_origin,size_contract");', 'implementation_origin,size_contract,poppy_policy,poppy_fpp_bits,poppy_bucket_bytes,poppy_cache_bytes,poppy_source_configuration");')
            text = replace_once(text, 'let hash = if name.starts_with("FastbloomRsRawK") {"public_raw8_two_seed_xxh3_64"} else {"public_common_hash64"};',
                'let hash = if name.starts_with("PoppyRawByte") {"public_poppy_natural_byte8"}\n        else if name.starts_with("PoppyRawTyped") {"public_poppy_natural_typed_u64"}\n        else if name.starts_with("FastbloomRsRawK") {"public_raw8_two_seed_xxh3_64"} else {"public_common_hash64"};')
            text = replace_once(text, 'println!(",{},{}", order, g.csv());', 'println!(",{},{},{}", order, g.csv(), poppy_geometry::metadata_csv(name));')
        result = text.encode();outputs[relative] = result
        recipes[relative] = dict(parent_commit=SOURCE, parent_path=name, parent_sha256=hashlib.sha256(raw).hexdigest(), sha256=hashlib.sha256(result).hexdigest(), unchanged=result == raw)
        if result != raw:
            outputs['changes/'+Path(relative).name+'.patch'] = ''.join(difflib.unified_diff(raw.decode().splitlines(True), text.splitlines(True), fromfile='frozen/'+relative, tofile='bridge/'+relative)).encode()
    outputs['benchmark/src/poppy_geometry.rs'] = geometry(values)
    outputs['geometry-union.json'] = blob(SELECTION, UNION)
    outputs['SOURCE_RECIPES.json'] = (json.dumps(dict(parent_commit=SOURCE, selection_commit=SELECTION, selection_path=UNION, recipes=recipes), indent=2)+'\n').encode()
    return outputs


def main():
    p = argparse.ArgumentParser();p.add_argument('--write', action='store_true');args = p.parse_args()
    outputs = expected()
    for relative, content in outputs.items():
        target = HERE/relative
        if args.write:
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists(): assert target.read_bytes() == content, 'Preserve edited source '+relative
            else: target.write_bytes(content)
        else:
            assert target.read_bytes() == content, 'Derived source drift '+relative
    for relative in ('benchmark/src/reporter.rs', 'benchmark/src/raw_contract.rs'):
        assert outputs[relative] == blob(SOURCE, PARENT+'/'+relative)
    print(json.dumps(dict(derived_artifacts=len(outputs), registered_apis=73, retained_apis=45, new_input_forms=28, compiler_or_bf=False)))


if __name__ == '__main__': main()
