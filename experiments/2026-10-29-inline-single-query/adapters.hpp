#pragma once
#include "../2026-10-29-external-parallel-query/snapshot/benchmarks/cpp-external/adapters.hpp"
#include "boost-direct.hpp"
#ifdef BF_ROCKSDB
#include "../2026-10-29-external-parallel-query/snapshot/benchmarks/rocksdb-external/adapters.hpp"
#else
#define BF_REGISTER_ROCKSDB_FILTERS(ADD)
#endif
#ifdef BF_NATIVE_LAYOUTS
#include "../2026-10-29-external-parallel-query/snapshot/include/four_sector_bloom.h"
#include "../2026-10-29-external-parallel-query/snapshot/include/split64_bloom.h"
#include "../2026-10-29-external-parallel-query/snapshot/include/byte_split_bloom.h"
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
#include "../2026-10-29-direct-split/direct_split.hpp"
#include "independent_vbmi_control.hpp"
using IndependentVbmi32 = independent_vbmi_experiment::IndependentVbmi32;
using IndependentVbmi32Single = direct_split_experiment::SingleShortcut<IndependentVbmi32>;
using IndependentSplit32 = direct_split_experiment::IndependentSplit32;
using IndependentSplit32Single = direct_split_experiment::SingleShortcut<IndependentSplit32>;
#ifdef BF_INLINE_REPRESENTATIVE
#define BF_INLINE_BASE(ADD) \
    ADD(FourSectorBloomFilter, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t); \
    ADD(FastFilterFixed16, uint64_t); \
    ADD(FastFilterFixed16SingleV1, uint64_t); \
    ADD(FastFilterFixed32Bulk, uint64_t); \
    ADD(FastFilterSimdBlock, uint64_t); \
    ADD(FastFilterSimdBlockSingleV1, uint64_t); \
    ADD(Boost192Multi64K8, uint64_t); \
    ADD(Boost192ClassicK11, uint64_t); \
    ADD(RocksDBFastLocalBloom64, uint64_t); \
    ADD(RocksDBFastLocalBloom64K8Batch32, uint64_t); \
    ADD(PageBloom6Default, uint64_t)
#else
#define BF_INLINE_BASE(ADD) \
    BF_REGISTER_FASTFILTER_FILTERS(ADD); \
    BF_REGISTER_BOOST_FILTERS(ADD); \
    BF_REGISTER_ROCKSDB_FILTERS(ADD); \
    BF_REGISTER_NATIVE_LAYOUT_FILTERS(ADD)
#endif
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_INLINE_BASE(ADD); \
    ADD(IndependentVbmi32, uint64_t); \
    ADD(IndependentVbmi32Single, uint64_t); \
    ADD(IndependentSplit32, uint64_t); \
    ADD(IndependentSplit32Single, uint64_t)
