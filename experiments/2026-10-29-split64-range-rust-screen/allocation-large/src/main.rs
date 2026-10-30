#![allow(dead_code, unused_imports)] // Correctness-only frozen adapter prefix.
include!("../../preflight/audit-current/src/prefix.rs");
include!("allocation.rs");

fn check<F: Filter>(name: &str, n: usize, cap: u32) {
    // Warm one-time CPU/hash setup outside per-filter allocation observation.
    drop(F::new(64, 16).unwrap());
    let plan = geometry::plan(name, n, cap).unwrap();
    let (filter, allocated) = allocation::measure(|| F::new(n, cap).unwrap());
    std::hint::black_box(&filter); // Keep the constructed bitmap observable.
    assert_eq!(allocated.allocations, 1, "hidden retained/temporary constructor allocation");
    assert_eq!(allocated.deallocations, 0, "hidden temporary constructor allocation");
    assert_eq!(allocated.bytes, plan.allocated_bytes, "observed backing differs from plan");
    assert_eq!(filter.size_in_bytes(), allocated.bytes);
    assert!(allocated.bytes <= plan.budget_bytes);
    let (_, freed) = allocation::measure(|| drop(filter));
    assert_eq!(freed.deallocations, 1);
    assert_eq!(freed.freed_bytes, allocated.bytes);
    // Drop completes before reporting or allocating the next bitmap.
    println!("{{\"filter\":\"{name}\",\"keys\":{n},\"budget_bpk\":{cap},\"budget_bytes\":{},\"filter_bytes\":{},\"logical_bytes\":{},\"effective_probes\":{},\"allocations\":{},\"allocated_bytes\":{},\"constructor_deallocations\":{},\"max_alignment\":{},\"deallocations\":{},\"freed_bytes\":{}}}",
        plan.budget_bytes, plan.allocated_bytes, plan.logical_bytes, plan.effective_probes,
        allocated.allocations, allocated.bytes, allocated.deallocations, allocated.max_alignment,
        freed.deallocations, freed.freed_bytes);
}

fn main() {
    for n in [1 << 16, 1 << 25] {
        for cap in [16, 24, 32] {
            check::<BloomFilter<true>>("FastPatternBF", n, cap);
            check::<ByteSplitBloomFilter>("ByteSplitBloomFilter", n, cap);
            check::<FourSectorBloomFilter>("FourSectorBloomFilter", n, cap);
            check::<Split64BloomFilter>("Split64BloomFilter", n, cap);
            check::<Fastbloom017>("Fastbloom017", n, cap);
            check::<BloomsdayPinned>("BloomsdayPinned", n, cap);
            check::<SbbfSafePinned>("SbbfSafePinned", n, cap);
            check::<Split64RangeBloomFilter>("Split64RangeBloomFilter", n, cap);
        }
    }
}
