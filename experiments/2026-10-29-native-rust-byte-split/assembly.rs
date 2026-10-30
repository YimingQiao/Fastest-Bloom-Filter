extern crate fastest_bloom_filter;
use fastest_bloom_filter::ByteSplitBloomFilter;
#[no_mangle]
pub fn byte_split_one(filter: &ByteSplitBloomFilter, hash: u64) -> bool {
    filter.contains_hash(hash)
}
