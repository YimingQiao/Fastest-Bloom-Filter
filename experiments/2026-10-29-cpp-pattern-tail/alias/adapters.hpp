#pragma once
#include "before.h"
#include "after_policy.h"
#include "after_local.h"
#include "after_restrict.h"
using bloom_filters::FastPatternBeforeTailBF;
using bloom_filters::FastPatternEntryTailBF;
using bloom_filters::FastPatternLocalTailBF;
using bloom_filters::FastPatternRestrictTailBF;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(FastPatternBeforeTailBF, uint64_t); \
 ADD(FastPatternEntryTailBF, uint64_t); \
 ADD(FastPatternLocalTailBF, uint64_t); \
 ADD(FastPatternRestrictTailBF, uint64_t)
