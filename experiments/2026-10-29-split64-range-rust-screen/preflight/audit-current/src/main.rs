#![allow(dead_code, unused_imports)] // Untimed copied adapter prefix includes unused timer imports.
include!("prefix.rs");
include!("../../dense_dump.inc.rs");
fn main() {
    for n in [64, 1024, 65_536] {
        for cap in [16, 24, 32] {
            dump::<BloomFilter<true>>("FastPatternBF", n, cap, cap);
            dump::<ByteSplitBloomFilter>("ByteSplitBloomFilter", n, cap, cap);
            dump::<FourSectorBloomFilter>("FourSectorBloomFilter", n, cap, cap);
            dump::<Split64BloomFilter>("Split64BloomFilter", n, cap, cap);
            dump::<Fastbloom017>("Fastbloom017", n, cap, cap);
            dump::<BloomsdayPinned>("BloomsdayPinned", n, cap, cap);
            dump::<SbbfSafePinned>("SbbfSafePinned", n, cap, cap);
            dump::<Split64RangeBloomFilter>("Split64RangeBloomFilter", n, cap, cap);
        }
    }
}
