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

fn family<B: Filter, S: Filter>(cases: &[(usize, u32)]) {
    for &(n, bpk) in cases {
        let mut base = B::new(n, bpk).unwrap();
        let mut single = S::new(n, bpk).unwrap();
        assert_eq!(base.size_in_bytes(), single.size_in_bytes());
        let mut inserted: Vec<_> = (0..n.min(8192) as u64).map(hash64).collect();
        inserted.extend((0..256).map(|i| (7u64 << 32) | (hash64(i) & 0xffff_ffff)));
        inserted.extend([0, u64::MAX]);
        for chunk in inserted.chunks(7) {
            base.insert_hashes(chunk);
            single.insert_hashes(chunk);
        }
        base.insert_hashes(&inserted);
        single.insert_hashes(&inserted);
        for len in (0..=131).chain([4096, 4097]) {
            for offset in 0..8 {
                let input: Vec<_> = (0..offset + len)
                    .map(|i| {
                        if i % 3 == 0 {
                            inserted[i % inserted.len()]
                        } else {
                            hash64(1_000_000 + i as u64)
                        }
                    })
                    .collect();
                let input = &input[offset..];
                let mut expected = vec![0xfeed; len + 2];
                let mut actual = expected.clone();
                base.lookup_hashes(input, &mut expected[1..=len]);
                single.lookup_hashes(input, &mut actual[1..=len]);
                assert_eq!(expected, actual, "n={n} len={len} offset={offset}");
                assert_eq!(actual[0], 0xfeed);
                assert_eq!(actual[len + 1], 0xfeed);
            }
        }
        for hash in inserted {
            let mut a = [0];
            let mut b = [0];
            base.lookup_hashes(std::slice::from_ref(&hash), &mut a);
            single.lookup_hashes(std::slice::from_ref(&hash), &mut b);
            assert_eq!(a, [1]);
            assert_eq!(b, [1]);
        }
    }
}

#[test]
fn native_single_controls_exact_outputs_and_guards() {
    let cases = [(64, 8), (65_536, 8), (1 << 20, 16)];
    family::<ByteSplitBloomFilter, ByteNativeSingleApiV1>(&cases);
    family::<Split64BloomFilter, SplitNativeSingleApiV1>(&cases);
    family::<BloomFilter<true>, FastPatternSingleApiV1>(&cases);
    family::<FourSectorBloomFilter, FourSectorNativeSingleApiV1>(&cases);
}

#[test]
fn external_single_controls_exact_outputs_and_guards() {
    let cases = [(64, 8), (65_536, 8), (1 << 20, 16)];
    family::<BloomsdayPinned, BloomsdaySingleApiV1>(&cases);
    family::<Fastbloom017, FastbloomSingleApiV1>(&cases);
    family::<SbbfSafePinned, SbbfSafeSingleApiV1>(&cases);
}

fn lengths<F: Filter>() {
    let filter = F::new(64, 8).unwrap();
    for (input_len, output_len) in [(0, 1), (1, 0), (1, 2), (3, 2)] {
        let input = vec![0; input_len];
        let mut output = vec![0xfeed; output_len];
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            filter.lookup_hashes(&input, &mut output);
        }));
        assert!(result.is_err());
        assert!(output.iter().all(|&value| value == 0xfeed));
    }
}

#[test]
fn all_fourteen_paths_reject_mismatched_lengths_before_writing() {
    lengths::<ByteSplitBloomFilter>();
    lengths::<ByteNativeSingleApiV1>();
    lengths::<Split64BloomFilter>();
    lengths::<SplitNativeSingleApiV1>();
    lengths::<FourSectorBloomFilter>();
    lengths::<FourSectorNativeSingleApiV1>();
    lengths::<BloomFilter<true>>();
    lengths::<FastPatternSingleApiV1>();
    lengths::<BloomsdayPinned>();
    lengths::<BloomsdaySingleApiV1>();
    lengths::<Fastbloom017>();
    lengths::<FastbloomSingleApiV1>();
    lengths::<SbbfSafePinned>();
    lengths::<SbbfSafeSingleApiV1>();
}
