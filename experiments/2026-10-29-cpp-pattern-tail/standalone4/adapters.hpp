#pragma once
#include "before.h"
#include "after_standalone.h"
using bloom_filters::FastPatternBeforeTailBF;
using bloom_filters::FastPatternStandalone4BF;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(FastPatternBeforeTailBF, uint64_t); \
 ADD(FastPatternStandalone4BF, uint64_t)
