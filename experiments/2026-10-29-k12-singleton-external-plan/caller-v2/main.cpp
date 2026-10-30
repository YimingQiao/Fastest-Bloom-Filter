// Namespace binding only. Preserve the original native-header include order.
#include "../caller/fast_pattern_BF.h"
#include "../caller/four_sector_bloom.h"
#include "../caller/split64_bloom.h"
#include "../caller/byte_split_bloom.h"
#include "../caller/split64_range_bloom.h"
#include "../caller/control.h"
#include "../caller/candidate.h"
using bloom_filters::FourSectorBloomFilter;
using bloom_filters::Split64BloomFilter;
using bloom_filters::ByteSplitBloomFilter;
using bloom_filters::FourSectorRange12BloomFilter;
using bloom_filters::FourSectorRange12SingletonVectorExperiment;
using bloom_filters::Split64RangeBloomFilter;
#include "../caller/main.cpp"
