#pragma once
#include "../cpp-external/adapters.hpp"
#include "../boost-external/adapters.hpp"
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
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_REGISTER_FASTFILTER_FILTERS(ADD); \
    BF_REGISTER_BOOST_FILTERS(ADD); \
    BF_REGISTER_WIDE_FILTERS(ADD)
