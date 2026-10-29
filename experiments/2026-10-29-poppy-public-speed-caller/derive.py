#!/usr/bin/env python3
"""Append fixed public Poppy adapters; preserve the prior timed caller body."""
from pathlib import Path
import hashlib
import json
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = "72625673e6b5bb57874a5fa53e04d23ffb8c6ab2"
OLD = "experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark/"
PLAN = "4d2b7f69d941991f3a9f4cebeb2c7c87514cd8f0"
SELECTION = "experiments/2026-10-29-poppy-public-speed-plan/selection.json"


def derive():
    selection = subprocess.check_output(
        ["git", "show", PLAN + ":" + SELECTION], cwd=ROOT
    )
    assert selection == (ROOT / SELECTION).read_bytes()
    points = [
        p
        for p in json.loads(selection)["configurations"]
        if p["owner"] == "poppy_external"
    ]
    points.sort(key=lambda p: p["filter"])
    assert len(points) == 47
    outputs, sources = {}, {}
    names = (
        subprocess.check_output(
            ["git", "ls-tree", "-r", "--name-only", PARENT, OLD], cwd=ROOT
        )
        .decode()
        .splitlines()
    )
    for name in names:
        data = subprocess.check_output(["git", "show", PARENT + ":" + name], cwd=ROOT)
        assert data == (ROOT / name).read_bytes()
        sources[name] = hashlib.sha256(data).hexdigest()
        if name.endswith("Cargo.lock"):
            # Preserve initial resolver input separately; actual combined lock is
            # generated offline and frozen before any compilation/filter runs.
            outputs["parent-Cargo.lock"] = data
        else:
            outputs["benchmark/" + name[len(OLD) :]] = data
    main = outputs["benchmark/src/main.rs"].decode()
    main = main.replace(
        "mod geometry;\n",
        'mod geometry;\nmod poppy_geometry;\ninclude!("poppy_adapter.rs");\n',
        1,
    )
    marker = '    "FourSectorRange12BloomFilter",\n];'
    assert main.count(marker) == 1
    main = main.replace(
        marker,
        '    "FourSectorRange12BloomFilter",\n'
        + "".join(f'    "{p["filter"]}",\n' for p in points)
        + "];",
    )
    main = main.replace(
        "    let calibration_power = number(10, 0);\n",
        '    let calibration_power = number(10, 0);\n    let order = args.get(11).map(String::as_str).unwrap_or("original");\n    assert!(matches!(order, "original" | "reverse"), "invalid filter order");\n',
    )
    main = main.replace("&& args.len() <= 11,", "&& args.len() <= 12,")
    main = main.replace(
        "    shuffle(&mut jobs, &mut rng);\n",
        '    shuffle(&mut jobs, &mut rng);\n    if order == "reverse" { jobs.reverse(); }\n',
    )
    marker = "            _ => unreachable!(),\n        }\n    }\n}\n\n#[cfg(test)]\nmod tests;"
    assert main.count(marker) == 1
    registrations = "".join(
        f'            "{p["filter"]}" => run::<PoppyPublic<{int(p["filter"][-3:])}>>(name, &inserted, &query, &c),\n'
        for p in points
    )
    main = main.replace(marker, registrations + marker)
    main += "\n#[cfg(test)]\nmod poppy_tests;\n"
    old_main = outputs["benchmark/src/main.rs"].decode()
    # All original adapters and every complete timed helper/workload function
    # (including RNG, hash, checks, repetitions, clock boundaries) are literal.
    begin, end = (
        "// Optional external baseline:",
        '#[path = "support/filter_selection.rs"]',
    )
    assert (
        main[main.index(begin) : main.index(end)]
        == old_main[old_main.index(begin) : old_main.index(end)]
    )
    outputs["benchmark/src/main.rs"] = main.encode()
    geo = outputs["benchmark/src/geometry.rs"].decode()
    marker = '        _ => return Err("unknown geometry family".into()),'
    assert geo.count(marker) == 1
    geo = geo.replace(
        marker,
        """        name if name.starts_with("PoppyPublic") => {
            let p = crate::poppy_geometry::by_name(name)?;
            p.check(n, bpk)?;
            g.allocated_bytes = p.bucket_bytes + p.cache_bytes;
            g.logical_bytes = p.bucket_bytes;
            g.unit_bytes = 4096;
            g.kind = "public_poppy_v2_bucket_plus_cache";
            g.effective_probes = p.probes;
            g.probe_policy = if p.cache_bytes == 0 { "bucket_probes_no_cache" } else { "bucket_probes_plus_cache" };
            g.constructor_argument = p.fpp_bits as usize;
            g.origin = "poppy_external";
        }
"""
        + marker,
    )
    outputs["benchmark/src/geometry.rs"] = geo.encode()
    cargo = outputs["benchmark/Cargo.toml"].decode()
    cargo = cargo.replace(
        'name = "fastest-bloom-filter-rust-k12-public-caller"',
        'name = "fastest-bloom-filter-poppy-public-caller"',
    )
    cargo = cargo.replace("../../../2026-", "../../2026-")
    cargo = cargo.replace(
        "[dependencies]\n",
        '[dependencies]\npoppy-filters = { path = "../../../build/poppy-source/poppy" }\n',
    )
    outputs["benchmark/Cargo.toml"] = cargo.encode()
    exact = outputs["benchmark/src/exact_tests.rs"].decode()
    marker = "            for name in FILTER_NAMES {\n                let plan"
    assert exact.count(marker) == 1
    exact = exact.replace(
        marker,
        '            for name in FILTER_NAMES {\n                if name.starts_with("PoppyPublic") { continue; }\n                let plan',
    )
    outputs["benchmark/src/exact_tests.rs"] = exact.encode()
    rows = []
    policies = {"none": "None", "space": "Space", "speed": "Speed", "best": "Best"}
    for p in points:
        c = p["canonical_constructor"]
        rows.append(
            f'    Point {{ id: {int(p["filter"][-3:])}, name: "{p["filter"]}", n: {p["keys"]}, budget_bpk: {p["run_budget_bpk"]}, fpp_bits: 0x{c["fpp_bits"]}, policy: poppy_filters::OptLevel::{policies[c["policy"]]}, bucket_bytes: {c["buckets"] * 4096}, cache_bytes: {c["cache_bytes"]}, probes: {c["probes"]} }},\n'
        )
    geometry = (
        """//! Generated literal constructors from the committed47-point source selection.
pub struct Point {
    pub id: usize, pub name: &'static str, pub n: usize, pub budget_bpk: u32,
    pub fpp_bits: u64, pub policy: poppy_filters::OptLevel,
    pub bucket_bytes: usize, pub cache_bytes: usize, pub probes: i32,
}
impl Point {
    pub fn check(&self, n: usize, bpk: u32) -> crate::geometry::Result<()> {
        if n != self.n || bpk != self.budget_bpk {
            return Err("Poppy requires its frozen real n and declared budget".into());
        }
        Ok(())
    }
}
pub const POINTS: &[Point] = &[
"""
        + "".join(rows)
        + """];
pub fn by_name(name: &str) -> crate::geometry::Result<&'static Point> {
    POINTS.iter().find(|p| p.name == name).ok_or_else(|| "unknown Poppy constructor".into())
}
pub fn by_id(id: usize) -> &'static Point {
    POINTS.iter().find(|p| p.id == id).expect("frozen Poppy type ID")
}
"""
    )
    outputs["benchmark/src/poppy_geometry.rs"] = geometry.encode()
    outputs["SOURCE_DERIVATION.json"] = (
        json.dumps(
            dict(
                parent=PARENT,
                plan=PLAN,
                original_files=sources,
                literal_preservation="All old adapters and complete timed helper/workload body unchanged; only registration, constructor geometry, strict post-shuffle order flag and legacy geometry-test exclusion added",
                generated_files={
                    k: hashlib.sha256(v).hexdigest() for k, v in outputs.items()
                },
            ),
            indent=2,
        )
        + "\n"
    ).encode()
    for name, data in outputs.items():
        target = HERE / name
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists():
            assert target.read_bytes() == data, "Changed generated file: " + name
        else:
            target.write_bytes(data)
    return len(outputs)


if __name__ == "__main__":
    print(json.dumps({"generated_files": derive(), "filter_runs": 0}))
