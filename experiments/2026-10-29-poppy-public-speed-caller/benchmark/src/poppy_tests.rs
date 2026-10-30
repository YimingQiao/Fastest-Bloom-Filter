use super::*;
use std::io::{self, Write};

struct EqualWriter<'a> {
    expected: &'a [u8],
    offset: usize,
}
impl Write for EqualWriter<'_> {
    fn write(&mut self, data: &[u8]) -> io::Result<usize> {
        let end = self.offset.checked_add(data.len()).unwrap();
        assert_eq!(data, &self.expected[self.offset..end]);
        self.offset = end;
        Ok(data.len())
    }
    fn flush(&mut self) -> io::Result<()> {
        Ok(())
    }
}

fn public_fixture<const ID: usize>() {
    let p = poppy_geometry::by_id(ID);
    let mut adapter = PoppyPublic::<ID>::new(p.n, p.budget_bpk).unwrap();
    let mut reference = poppy_filters::Params::new(p.n, f64::from_bits(p.fpp_bits))
        .opt(p.policy)
        .try_into_v2()
        .unwrap();
    let mut keys: Vec<_> = (0..1031).map(|i| hash64(0xf17e000000000000 + i)).collect();
    keys[..5].copy_from_slice(&[0, u64::MAX, 1 << 63, 1, u64::MAX]);
    let before = keys.clone();
    for chunk in keys.chunks(7) {
        adapter.insert_hashes(chunk);
    }
    for &h in &keys {
        let bytes = h.to_le_bytes();
        reference
            .insert_iter(poppy_filters::v2::BloomFilter::build_index_iter(
                &bytes.as_slice(),
            ))
            .unwrap();
    }
    adapter.insert_hashes(&keys);
    assert_eq!(keys, before);
    for &h in &keys {
        assert!(adapter.contains_hash(h));
    }
    assert_eq!(adapter.0.count_estimate(), reference.count_estimate());
    // Whole public serialization, not a digest-only equality assertion.
    let mut bytes = Vec::with_capacity(56 + p.bucket_bytes + p.cache_bytes);
    adapter.0.write(&mut bytes).unwrap();
    assert_eq!(bytes.len(), 56 + p.bucket_bytes + p.cache_bytes);
    let mut writer = EqualWriter {
        expected: &bytes,
        offset: 0,
    };
    reference.write(&mut writer).unwrap();
    assert_eq!(writer.offset, bytes.len());
    for len in [0, 1, 3, 4, 7, 31, 32, 63, 64, 8193] {
        let input: Vec<_> = (0..len)
            .map(|i| {
                if i % 2 == 1 {
                    keys[(i / 2) % keys.len()]
                } else {
                    hash64(0xe17e000000000000 + i as u64)
                }
            })
            .collect();
        let copy = input.clone();
        let expected: Vec<_> = input
            .iter()
            .map(|h| {
                let bytes = h.to_le_bytes();
                reference
                    .contains_iter(poppy_filters::v2::BloomFilter::build_index_iter(
                        &bytes.as_slice(),
                    ))
                    .unwrap() as u32
            })
            .collect();
        let mut output = vec![0xdeadbeef; len + 2];
        adapter.lookup_hashes(&input, &mut output[1..len + 1]);
        assert_eq!(&output[1..len + 1], expected);
        assert_eq!(output[0], 0xdeadbeef);
        assert_eq!(output[len + 1], 0xdeadbeef);
        visible_lookup::<PoppyPublic<ID>, false>(&adapter, &input, &mut output[1..len + 1]);
        assert_eq!(&output[1..len + 1], expected);
        let raw: Vec<_> = (0..len as u64).collect();
        let fused_expected: Vec<_> = raw
            .iter()
            .map(|&h| reference.contains_bytes(hash64(h).to_le_bytes()) as u32)
            .collect();
        visible_lookup::<PoppyPublic<ID>, true>(&adapter, &raw, &mut output[1..len + 1]);
        assert_eq!(&output[1..len + 1], fused_expected);
        assert_eq!(output[0], 0xdeadbeef);
        assert_eq!(output[len + 1], 0xdeadbeef);
        assert_eq!(input, copy);
    }
    let mut mismatch = [0xdeadbeef; 2];
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(
        || adapter.lookup_hashes(&[0], &mut mismatch)
    ))
    .is_err());
    assert_eq!(mismatch, [0xdeadbeef; 2]);
    assert!(PoppyPublic::<ID>::new(p.n - 1, p.budget_bpk).is_err());
    assert!(PoppyPublic::<ID>::new(p.n, p.budget_bpk + 1).is_err());
}

#[test]
fn eight_public_adapter_fixtures_keep_real_capacity_and_full_outputs() {
    public_fixture::<0>();
    public_fixture::<20>();
    public_fixture::<39>();
    public_fixture::<44>();
    public_fixture::<46>();
    public_fixture::<60>();
    public_fixture::<79>();
    public_fixture::<84>();
}

#[test]
fn all_literal_poppy_geometries_charge_cache_and_reject_wrong_inputs() {
    assert_eq!(poppy_geometry::POINTS.len(), 47);
    for p in poppy_geometry::POINTS {
        let g = geometry::plan(p.name, p.n, p.budget_bpk).unwrap();
        assert_eq!(g.allocated_bytes, p.bucket_bytes + p.cache_bytes);
        assert_eq!(g.logical_bytes, p.bucket_bytes);
        assert_eq!(g.effective_probes, p.probes);
        assert_eq!(g.constructor_argument as u64, p.fpp_bits);
        assert!(g.allocated_bytes <= g.budget_bytes);
        assert!(geometry::plan(p.name, p.n - 1, p.budget_bpk).is_err());
        assert!(geometry::plan(p.name, p.n, p.budget_bpk + 1).is_err());
    }
    assert!(geometry::plan("PoppyPublic999", 65536, 24).is_err());
}
