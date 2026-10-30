// CSV formatting is outside every timing interval. No prehashed columns exist.
fn report_header() {
    let names = vec!["language", "filter", "keys", "queries", "requested_bpk", "filter_bytes",
        "actual_bpk", "hit_percent", "present_queries", "batch", "insert_batch", "repeats", "seed", "key_base",
        "raw_hash_contract", "build_scratch_bytes", "query_scratch_bytes", "absent_queries",
        "false_positives", "result_checksum", "calibration_absent_queries", "calibration_false_positives"];
    print!("{}", names.join(","));
    for metric in ["raw_batched_public", "raw_visible_public", "raw_insert", "allocate_filter_and_scratch_raw_insert"] {
        for suffix in ["ns", "min_ns", "max_ns", "trials"] { print!(",{metric}_{suffix}"); }
    }
    println!(",query_phase_order,budget_bytes,logical_bytes,geometry_kind,unit_bytes,unit_count,effective_probes,probe_policy,constructor_argument,implementation_origin,size_contract");
}
fn report<F: RawFilter>(name: &str, inserted: &[u64], query: &[u64], c: &Config) {
    let m = reporter::run_raw::<F>(inserted, query, c);
    let g = geometry::plan(name, c.n, c.bpk).unwrap();
    assert_eq!(m.actual_bytes, g.allocated_bytes, "actual backing allocation differs from plan");
    assert_eq!((m.insert_batch, m.query_batch), (c.insert_batch, c.batch));
    let hash = if name.starts_with("FastbloomRsRawK") {"public_raw8_two_seed_xxh3_64"} else {"public_common_hash64"};
    let fields = vec!["rust".to_string(), name.to_string(), c.n.to_string(), c.q.to_string(), c.bpk.to_string(),
        m.actual_bytes.to_string(), (m.actual_bytes as f64 * 8.0 / c.n as f64).to_string(), c.hit.to_string(),
        m.present.to_string(), c.batch.to_string(), c.insert_batch.to_string(), c.repeats.to_string(), c.seed.to_string(),
        c.key_base.to_string(), hash.to_string(), m.build_scratch_bytes.to_string(), m.query_scratch_bytes.to_string(),
        m.absent.to_string(), m.false_positives.to_string(), m.checksum.to_string(), m.calibration_absent.to_string(),
        m.calibration_false_positives.to_string()];
    print!("{}", fields.join(","));
    for samples in [&m.raw_batched_trials, &m.raw_visible_trials, &m.raw_insert_trials,
        &m.allocate_filter_and_scratch_raw_insert_trials] {
        assert_eq!(samples.len(), c.repeats);
        assert!(samples.iter().all(|x| x.is_finite() && *x >= 0.0));
        print!(",{},{},{},{}", median(samples), samples.iter().copied().fold(f64::INFINITY, f64::min),
            samples.iter().copied().fold(0.0, f64::max), trial_string(samples));
    }
    let order = m.query_phase_order.iter().map(|x| format!("{}|{}", x[0], x[1])).collect::<Vec<_>>().join(";");
    println!(",{},{}", order, g.csv());
}
