#pragma once
#include "cpp-adapters.hpp"
#include "boost-adapters.hpp"
#include "rocks-adapters.hpp"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
using FourSectorBloomFilter = bloom_filters::FourSectorBloomFilter;
using Split64BloomFilter = bloom_filters::Split64BloomFilter;
using ByteSplitBloomFilter = bloom_filters::ByteSplitBloomFilter;
#include "range-layouts/byte_split_bloom.h"
#include "range-layouts/split64_bloom.h"
using ByteSplitRangeExperiment = bloom_filters::ByteSplitRange;
using Split64RangeExperiment = bloom_filters::Split64Range;
#include "cyclic_split64.h"
using CyclicSplit64RangeExperiment = bloom_filters::CyclicSplit64Range;
#include "multiply_code_split64.h"
using MultiplyCodeSplit64RangeExperiment = bloom_filters::MultiplyCodeSplit64Range;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_REGISTER_FASTFILTER_FILTERS(ADD); \
    BF_REGISTER_BOOST_FILTERS(ADD); \
    BF_REGISTER_ROCKSDB_FILTERS(ADD); \
    ADD(FourSectorBloomFilter, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t); \
    ADD(ByteSplitRangeExperiment, uint64_t); \
    ADD(Split64RangeExperiment, uint64_t); \
    ADD(CyclicSplit64RangeExperiment, uint64_t); \
    ADD(MultiplyCodeSplit64RangeExperiment, uint64_t)
#define BF_REGISTER_ALL_FILTERS(ADD) \
    ADD(bloom_filters::FastPatternBF, uint64_t); \
    BF_REGISTER_EXTERNAL_FILTERS(ADD)
