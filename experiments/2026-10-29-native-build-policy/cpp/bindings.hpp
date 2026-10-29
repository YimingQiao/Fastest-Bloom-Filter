#pragma once
#include "../../2026-10-29-split64-range-native-scaling/cpp/native/parallel_layout_bloom.h"
#include "../../2026-10-29-split64-range-native-scaling/cpp/range/parallel_split64_range.h"
#include "policy.hpp"

namespace native_build_policy {
using SplitControl = Filter<bloom_filters::ParallelSplit64BloomFilter, false>;
using SplitBounded = Filter<bloom_filters::ParallelSplit64BloomFilter, true>;
using RangeControl = Filter<bloom_filters::ParallelSplit64RangeBloomFilter, false>;
using RangeBounded = Filter<bloom_filters::ParallelSplit64RangeBloomFilter, true>;
} // namespace native_build_policy
