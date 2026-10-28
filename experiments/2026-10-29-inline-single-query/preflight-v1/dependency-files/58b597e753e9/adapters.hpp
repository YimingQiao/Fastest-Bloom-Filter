#pragma once
#include "snapshot/benchmarks/all-external/adapters.hpp"
// Optional small compilation/validation target. The full benchmark retains the
// entire frozen registration; this explicit subset spans each ownership/API form.
#ifdef BF_MT_REPRESENTATIVE
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
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
#endif
