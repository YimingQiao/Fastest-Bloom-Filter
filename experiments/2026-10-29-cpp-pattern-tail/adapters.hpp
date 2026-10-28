#pragma once
#include "before.h"
#include "after.h"
#include "after_grouped.h"
using FastPatternBeforeTailBF = bloom_filters::FastPatternBeforeTailBF;
using FastPatternMaskedTailBF = bloom_filters::FastPatternMaskedTailBF;
using FastPatternGroupedTailBF = bloom_filters::FastPatternGroupedTailBF;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
	ADD(FastPatternBeforeTailBF, uint64_t); \
	ADD(FastPatternMaskedTailBF, uint64_t); \
	ADD(FastPatternGroupedTailBF, uint64_t)
