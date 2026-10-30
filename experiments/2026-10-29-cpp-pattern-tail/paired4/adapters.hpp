#pragma once
#include "before.h"
#include "after_paired4.h"
using bloom_filters::FastPatternBeforeTailBF;
using bloom_filters::FastPatternPair4TailBF;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(FastPatternBeforeTailBF, uint64_t); \
 ADD(FastPatternPair4TailBF, uint64_t)
