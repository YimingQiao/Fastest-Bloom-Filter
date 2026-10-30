#pragma once
#include "exact-adapters.hpp"
#include "native-range/split64_bloom.h"
using Split64RangeNative = bloom_filters::Split64RangeNative;
// Fixed union of the prior MT shortlist, native Range, and the
// already-known ClassicK11 exact-capacity rival. No timing selection.
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    ADD(Boost192Multi32K7, uint64_t); \
    ADD(Boost192Multi32K8, uint64_t); \
    ADD(Boost192Multi64K8, uint64_t); \
    ADD(ByteSplitBloomFilter, uint64_t); \
    ADD(FastFilterFixed16, uint64_t); \
    ADD(FastFilterFixed16SingleV1, uint64_t); \
    ADD(FastFilterFixed32, uint64_t); \
    ADD(FastFilterFixed32Bulk, uint64_t); \
    ADD(FastFilterFixed64, uint64_t); \
    ADD(FastFilterSimdBlock, uint64_t); \
    ADD(FastFilterSimdBlockSingleV1, uint64_t); \
    ADD(FourSectorBloomFilter, uint64_t); \
    ADD(PageBloom6Compact, uint64_t); \
    ADD(RocksDBFastLocalBloom64, uint64_t); \
    ADD(RocksDBFastLocalBloom64Batch32, uint64_t); \
    ADD(RocksDBFastLocalBloom64K14, uint64_t); \
    ADD(RocksDBFastLocalBloom64K14Batch32, uint64_t); \
    ADD(RocksDBFastLocalBloom64K8, uint64_t); \
    ADD(RocksDBFastLocalBloom64K8Batch32, uint64_t); \
    ADD(RocksDBFastLocalBloom64K9, uint64_t); \
    ADD(RocksDBFastLocalBloom64K9Batch32, uint64_t); \
    ADD(Split64BloomFilter, uint64_t); \
    ADD(Boost192ClassicK11, uint64_t); \
    ADD(Split64RangeNative, uint64_t)
