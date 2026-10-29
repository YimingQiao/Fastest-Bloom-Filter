// Must fail: the old power-of-two shard implementation cannot access K12.
#include "parallel_layout_bloom.h"
#include "four_sector_range12_bloom.h"
int main() {
    bloom_filters::ParallelLayoutBloomFilter<bloom_filters::FourSectorRange12BloomFilter> filter(65536, 24);
    return static_cast<int>(filter.BuildWorkers(32768, 3));
}
