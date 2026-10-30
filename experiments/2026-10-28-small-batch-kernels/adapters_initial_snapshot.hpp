#pragma once
#include "fast_pattern_before.h"
#include "fast_pattern_early.h"
#include "split64_before.hpp"
#include "split64_wide.hpp"
#include "../../benchmarks/cpp-external/adapters.hpp"
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD)                                                                              \
	ADD(FastPatternBeforeSmallBF, uint64_t);                                                                           \
	ADD(FastPatternEarlySmallBF, uint64_t);                                                                            \
	ADD(Split64P32, uint64_t);                                                                                         \
	ADD(Split64WideP32, uint64_t);                                                                                     \
	ADD(FastFilterSimdBlock, uint64_t);                                                                                \
	ADD(FastFilterFixed64, uint64_t);                                                                                  \
	ADD(FastFilterFixed16, uint64_t)
