#pragma once
#include "independent_vbmi.hpp"
#include "../2026-10-29-direct-split/direct_split.hpp"
#include "../../include/byte_split_bloom.h"
#include "../../include/split64_bloom.h"
#include "../../benchmarks/cpp-external/adapters.hpp"
using IndependentVbmi32 = independent_vbmi_experiment::IndependentVbmi32;
using IndependentVbmi32Single = direct_split_experiment::SingleShortcut<IndependentVbmi32>;
using IndependentSplit32 = direct_split_experiment::IndependentSplit32;
using IndependentSplit32Single = direct_split_experiment::SingleShortcut<IndependentSplit32>;
using ByteSplitBloomFilter = bloom_filters::ByteSplitBloomFilter;
using Split64BloomFilter = bloom_filters::Split64BloomFilter;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    ADD(IndependentVbmi32, uint64_t); \
    ADD(IndependentVbmi32Single, uint64_t); \
    ADD(IndependentSplit32, uint64_t); \
    ADD(IndependentSplit32Single, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(FastFilterFixed16SingleV1, uint64_t); \
    ADD(FastFilterSimdBlock, uint64_t); \
    ADD(FastFilterSimdBlockSingleV1, uint64_t); \
    ADD(FastFilterFixed32, uint64_t)
