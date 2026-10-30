#![allow(dead_code, unused_imports)] // Untimed copied adapter prefix includes unused timer imports.
include!("prefix.rs");
include!("../../dense_dump.inc.rs");
fn main() {
    for n in [64, 1024, 65_536] {
        for cap in [16, 32] {
            let old_requested_bpk = cap / 2;
            dump::<BloomFilter<true>>("FastPatternBF", n, cap, old_requested_bpk);
            dump::<ByteSplitBloomFilter>("ByteSplitBloomFilter", n, cap, old_requested_bpk);
            dump::<FourSectorBloomFilter>("FourSectorBloomFilter", n, cap, old_requested_bpk);
            dump::<Split64BloomFilter>("Split64BloomFilter", n, cap, old_requested_bpk);
            dump::<Fastbloom017>("Fastbloom017", n, cap, old_requested_bpk);
            dump::<BloomsdayPinned>("BloomsdayPinned", n, cap, old_requested_bpk);
            dump::<SbbfSafePinned>("SbbfSafePinned", n, cap, old_requested_bpk);
        }
    }
}
