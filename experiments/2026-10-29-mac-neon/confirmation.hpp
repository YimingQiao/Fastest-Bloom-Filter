#pragma once
#include "../../benchmarks/boost-external/adapters.hpp"
#include "arm_external.hpp"
#include "word_pattern.hpp"

// Frozen controls share the compiler, harness, process and randomized job order
// with current native types and the unchanged public Boost batch API.
#define FastPatternBF MacOriginalPattern
#include "fast_pattern_original.h"
#undef FastPatternBF
#pragma push_macro("BF_DISABLE_NEON")
#define BF_DISABLE_NEON 1
#define ByteSplitBloomFilter MacOriginalByteSplit
#include "byte_split_neon_v1.h"
#undef ByteSplitBloomFilter
#pragma pop_macro("BF_DISABLE_NEON")

#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_REGISTER_BOOST_FILTERS(ADD); \
    ADD(FastFilterArm16, uint64_t); \
    ADD(WordPattern4B6, uint64_t); \
    ADD(WordPattern4B6D128, uint64_t); \
    ADD(MacOriginalPattern, uint64_t); \
    ADD(MacOriginalByteSplit, uint64_t)
