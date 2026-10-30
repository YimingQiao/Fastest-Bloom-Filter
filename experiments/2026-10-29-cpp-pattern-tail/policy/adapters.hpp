#pragma once
#include "before.h"
#include "after_policy.h"
#include "after_grouped.h"
using FastPatternBeforeTailBF = bloom_filters::FastPatternBeforeTailBF;
using FastPatternEntryTailBF = bloom_filters::FastPatternEntryTailBF;
using FastPatternGroupedTailBF = bloom_filters::FastPatternGroupedTailBF;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
	ADD(FastPatternBeforeTailBF, uint64_t); \
	ADD(FastPatternEntryTailBF, uint64_t); \
	ADD(FastPatternGroupedTailBF, uint64_t)
