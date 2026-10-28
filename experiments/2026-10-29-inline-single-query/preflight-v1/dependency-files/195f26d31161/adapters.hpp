#pragma once
#include "../cpp-external/adapters.hpp"
#include "../boost-external/adapters.hpp"
#ifdef BF_ROCKSDB
#include "../rocksdb-external/adapters.hpp"
#else
#define BF_REGISTER_ROCKSDB_FILTERS(ADD)
#endif
#ifdef BF_NATIVE_LAYOUTS
#include "../../include/four_sector_bloom.h"
#include "../../include/split64_bloom.h"
#include "../../include/byte_split_bloom.h"
using FourSectorBloomFilter = bloom_filters::FourSectorBloomFilter;
using Split64BloomFilter = bloom_filters::Split64BloomFilter;
using ByteSplitBloomFilter = bloom_filters::ByteSplitBloomFilter;
#define BF_REGISTER_NATIVE_LAYOUT_FILTERS(ADD) \
    ADD(FourSectorBloomFilter, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t)
#else
#define BF_REGISTER_NATIVE_LAYOUT_FILTERS(ADD)
#endif
#if defined(BF_WIDE_EXPERIMENTS) && defined(__AVX512F__)
#include "../../experiments/2026-10-28-wide-pattern/wide_pattern.h"
using FastPattern64Experiment = wide_pattern::Filter<6, false>;
using FastPattern128Experiment = wide_pattern::Filter<7, false>;
#define BF_REGISTER_WIDE_FILTERS(ADD) \
    ADD(FastPattern64Experiment, uint64_t); \
    ADD(FastPattern128Experiment, uint64_t)
#else
#define BF_REGISTER_WIDE_FILTERS(ADD)
#endif
#if defined(BF_LAYOUT_EXPERIMENTS)
#define BF_FOUR_EXTERNAL_BASE 1
#define BF_FOUR_SIMD 1
#define MASK_TABLE_ENTRIES 16
#include "../../experiments/2026-10-28-four-sector/four_sector.h"
#include "../../experiments/2026-10-28-split64/split64.hpp"
using FourSector16K8 = bloom_filters::FourSectorBF<8>;
using Split64P32 = bloom_filters::Split64P32;
#define BF_REGISTER_LAYOUT_FILTERS(ADD) \
    ADD(FourSector16K8, uint64_t); \
    ADD(Split64P32, uint64_t)
#else
#define BF_REGISTER_LAYOUT_FILTERS(ADD)
#endif
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_REGISTER_FASTFILTER_FILTERS(ADD); \
    BF_REGISTER_BOOST_FILTERS(ADD); \
    BF_REGISTER_ROCKSDB_FILTERS(ADD); \
    BF_REGISTER_NATIVE_LAYOUT_FILTERS(ADD); \
    BF_REGISTER_WIDE_FILTERS(ADD); \
    BF_REGISTER_LAYOUT_FILTERS(ADD)
