use super::*;

pub(crate) mod allocation {
    use std::alloc::{GlobalAlloc, Layout, System};
    use std::cell::Cell;

    #[derive(Clone, Copy, Debug, Default)]
    pub(crate) struct Counts {
        pub allocations: usize,
        pub bytes: usize,
        pub max_alignment: usize,
        pub deallocations: usize,
        pub freed_bytes: usize,
    }
    thread_local! {
        static COUNTS: Cell<Option<Counts>> = const { Cell::new(None) };
    }
    struct AuditAllocator;
    #[global_allocator]
    static ALLOCATOR: AuditAllocator = AuditAllocator;

    fn allocated(layout: Layout) {
        let _ = COUNTS.try_with(|slot| {
            if let Some(mut counts) = slot.get() {
                counts.allocations += 1;
                counts.bytes += layout.size();
                counts.max_alignment = counts.max_alignment.max(layout.align());
                slot.set(Some(counts));
            }
        });
    }
    unsafe impl GlobalAlloc for AuditAllocator {
        unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
            allocated(layout);
            System.alloc(layout)
        }
        unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
            allocated(layout);
            System.alloc_zeroed(layout)
        }
        unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
            let _ = COUNTS.try_with(|slot| {
                if let Some(mut counts) = slot.get() {
                    counts.deallocations += 1;
                    counts.freed_bytes += layout.size();
                    slot.set(Some(counts));
                }
            });
            System.dealloc(ptr, layout);
        }
    }
    pub(crate) fn measure<T>(f: impl FnOnce() -> T) -> (T, Counts) {
        struct Reset;
        impl Drop for Reset {
            fn drop(&mut self) {
                COUNTS.with(|slot| slot.set(None));
            }
        }
        COUNTS.with(|slot| {
            assert!(slot.get().is_none());
            slot.set(Some(Counts::default()));
        });
        let reset = Reset;
        let value = f();
        let counts = COUNTS.with(|slot| slot.take().unwrap());
        drop(reset);
        (value, counts)
    }
}

thread_local! {
    static FAULT_MODE: std::cell::Cell<Option<usize>> = const { std::cell::Cell::new(None) };
}

pub(crate) fn maybe_corrupt_timed_tail(mode: usize, output: &mut [u32]) {
    FAULT_MODE.with(|fault| {
        if fault.get() == Some(mode) {
            fault.set(None);
            *output.last_mut().unwrap() ^= 1;
        }
    });
}

fn public_api_parity<F: Filter>() {
    for (n, bpk) in [(64, 8), (65_536, 8), (1 << 20, 16)] {
        let mut filter = F::new(n, bpk).unwrap();
        let raw_insert: Vec<_> = (0..n.min(4096) as u64).collect();
        let inserted: Vec<_> = raw_insert.iter().map(|&raw| hash64(raw)).collect();
        for chunk in inserted.chunks(7) {
            filter.insert_hashes(chunk);
        }
        filter.insert_hashes(&inserted);
        for &hash in &inserted {
            assert!(filter.contains_hash(hash));
        }
        for len in (0..=131).chain([4096, 4097]) {
            for offset in 0..8 {
                let raw: Vec<_> = (0..offset + len)
                    .map(|i| {
                        if i % 3 == 0 {
                            raw_insert[i % raw_insert.len()]
                        } else {
                            1_000_000 + i as u64
                        }
                    })
                    .collect();
                let raw = &raw[offset..];
                let hashed: Vec<_> = raw.iter().map(|&value| hash64(value)).collect();
                let mut base = vec![0xfeed; len + 2];
                let mut pure = base.clone();
                let mut fused = base.clone();
                filter.lookup_hashes(&hashed, &mut base[1..len + 1]);
                visible_lookup::<F, false>(&filter, &hashed, &mut pure[1..len + 1]);
                visible_lookup::<F, true>(&filter, raw, &mut fused[1..len + 1]);
                assert_eq!(
                    base, pure,
                    "visible prehash n={n} len={len} offset={offset}"
                );
                assert_eq!(base, fused, "visible raw n={n} len={len} offset={offset}");
                assert_eq!(base[0], 0xfeed);
                assert_eq!(base[len + 1], 0xfeed);
            }
        }
        for (input_len, output_len) in [(0, 1), (1, 0), (1, 2), (3, 2)] {
            let input = vec![0; input_len];
            for hash_raw in [false, true] {
                let mut output = vec![0xfeed; output_len];
                let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    if hash_raw {
                        visible_lookup::<F, true>(&filter, &input, &mut output);
                    } else {
                        visible_lookup::<F, false>(&filter, &input, &mut output);
                    }
                }));
                assert!(result.is_err());
                assert!(output.iter().all(|&value| value == 0xfeed));
            }
        }
    }
}

#[test]
fn all_twelve_public_apis_match_full_dense_outputs_and_guards() {
    public_api_parity::<BloomFilter<true>>();
    public_api_parity::<ByteSplitBloomFilter>();
    public_api_parity::<FourSectorBloomFilter>();
    public_api_parity::<Split64BloomFilter>();
    public_api_parity::<Fastbloom017>();
    public_api_parity::<BloomsdayPinned>();
    public_api_parity::<SbbfSafePinned>();
    public_api_parity::<ByteLeafInlineV1>();
    public_api_parity::<FourSectorLeafInlineV1>();
    public_api_parity::<Split64LeafInlineV1>();
    public_api_parity::<Independent32BloomFilter>();
    public_api_parity::<Independent32SingletonV1>();
}

#[test]
fn four_mode_order_balances_positions_and_predecessors() {
    for seed in [0, 42, 7919, u64::MAX] {
        let orders = phase_orders(seed, 8);
        let mut positions = [[0; 4]; 4];
        let mut predecessors = [[0; 4]; 4];
        for order in orders {
            for (position, mode) in order.iter().enumerate() {
                positions[position][*mode] += 1;
            }
            for pair in order.windows(2) {
                predecessors[pair[0]][pair[1]] += 1;
            }
        }
        assert_eq!(positions, [[2; 4]; 4]);
        for (from, counts) in predecessors.iter().enumerate() {
            for (to, count) in counts.iter().enumerate() {
                assert_eq!(*count, if from == to { 0 } else { 2 });
            }
        }
    }
}

struct ExactFilter(std::collections::HashSet<u64>);
impl Filter for ExactFilter {
    fn new(_: usize, _: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self(Default::default()))
    }
    fn size_in_bytes(&self) -> usize {
        128
    }
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains(&hash)
    }
    fn insert_hashes(&mut self, hashes: &[u64]) {
        self.0.extend(hashes.iter().copied());
    }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        for (&hash, answer) in hashes.iter().zip(out.iter_mut()) {
            *answer = self.contains_hash(hash) as u32;
        }
    }
}

#[test]
fn actual_harness_detects_corrupt_last_output_in_every_timed_mode() {
    let c = Config {
        n: 32,
        q: 128,
        bpk: 8,
        hit: 25,
        batch: 1,
        insert_batch: 32,
        calibration_power: 0,
        repeats: 4,
        seed: 42,
        key_base: 0,
    };
    for (mode, phase) in PHASE_NAMES.iter().enumerate() {
        FAULT_MODE.with(|fault| fault.set(Some(mode)));
        let result = std::panic::catch_unwind(|| {
            run::<ExactFilter>(
                "fault",
                &(0..32).collect::<Vec<_>>(),
                &(0..128).collect::<Vec<_>>(),
                &c,
            )
        });
        FAULT_MODE.with(|fault| fault.set(None));
        let error = result.expect_err("actual timed tail corruption was accepted");
        let message = error
            .downcast_ref::<String>()
            .map(String::as_str)
            .or_else(|| error.downcast_ref::<&str>().copied())
            .unwrap_or("");
        assert!(message.contains(phase), "wrong failed mode: {message}");
        assert!(message.contains("output differs from warmup"));
    }
}

fn candidate_pair<A: Filter, B: Filter>() {
    for (n, bpk) in [(64, 8), (65_536, 8), (1 << 20, 16)] {
        let mut original = A::new(n, bpk).unwrap();
        let mut candidate = B::new(n, bpk).unwrap();
        assert_eq!(original.size_in_bytes(), candidate.size_in_bytes());
        let mut inserted: Vec<u64> = (0..4096).map(hash64).collect();
        inserted.extend([0, 0, u64::MAX, u64::MAX, 1u64 << 32, 1u64 << 32]);
        for chunk in inserted.chunks(17) {
            original.insert_hashes(chunk);
            candidate.insert_hashes(chunk);
        }
        original.insert_hashes(&inserted);
        candidate.insert_hashes(&inserted);
        let queries: Vec<u64> = (0..8192)
            .map(|i| {
                if i % 3 == 0 {
                    inserted[i % inserted.len()]
                } else {
                    hash64(100_000 + i as u64)
                }
            })
            .collect();
        for &hash in &inserted {
            assert!(original.contains_hash(hash));
            assert!(candidate.contains_hash(hash));
        }
        for &hash in &queries {
            assert_eq!(original.contains_hash(hash), candidate.contains_hash(hash));
        }
        for length in (0..=131).chain([4096, 4097]) {
            for offset in 0..8 {
                let input = &queries[offset..offset + length];
                let mut old = vec![0xfeed; length + 2];
                let mut new = old.clone();
                original.lookup_hashes(input, &mut old[1..length + 1]);
                candidate.lookup_hashes(input, &mut new[1..length + 1]);
                assert_eq!(
                    old, new,
                    "candidate parity n={n} len={length} offset={offset}"
                );
                assert_eq!((new[0], new[length + 1]), (0xfeed, 0xfeed));
            }
        }
    }
}

#[test]
fn exactly_three_hint_candidates_preserve_original_public_outputs() {
    candidate_pair::<ByteSplitBloomFilter, ByteLeafInlineV1>();
    candidate_pair::<FourSectorBloomFilter, FourSectorLeafInlineV1>();
    candidate_pair::<Split64BloomFilter, Split64LeafInlineV1>();
}
