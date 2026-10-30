#pragma once
#include "snapshot/include/byte_split_bloom.h"
#include "snapshot/direct_split.hpp"
#include "snapshot/fastfilter_adapters.hpp"
using ByteSplitBloomFilter = bloom_filters::ByteSplitBloomFilter;
using ByteSplitFrozenSingle = direct_split_experiment::SingleShortcut<direct_split_experiment::ByteSplit128>;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
	ADD(ByteSplitBloomFilter, uint64_t); \
	ADD(ByteSplitFrozenSingle, uint64_t); \
	ADD(FastFilterFixed16, uint64_t); \
	ADD(FastFilterFixed16SingleV1, uint64_t)
