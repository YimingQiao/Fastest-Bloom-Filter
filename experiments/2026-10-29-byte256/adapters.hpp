#pragma once
#include "byte256.hpp"
#include "../../include/byte_split_bloom.h"
#include "../../include/split64_bloom.h"
#include "../../benchmarks/cpp-external/adapters.hpp"
using ByteSplitBloomFilter = bloom_filters::ByteSplitBloomFilter;
using Split64BloomFilter = bloom_filters::Split64BloomFilter;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    ADD(ByteSplit256Experiment, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(FastFilterFixed16, uint64_t); \
    ADD(FastFilterFixed16SingleV1, uint64_t); \
    ADD(FastFilterSimdBlock, uint64_t); \
    ADD(FastFilterSimdBlockSingleV1, uint64_t); \
    ADD(FastFilterFixed32, uint64_t)
