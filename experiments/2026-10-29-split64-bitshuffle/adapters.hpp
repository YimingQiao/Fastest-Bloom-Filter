#pragma once
#include "before.h"
#include "after.h"
using Split64Original = bloom_filters::Split64BitShuffleOriginal;
using Split64BitShuffleHybrid = bloom_filters::Split64BitShuffleCandidate<0>;
using Split64BitShuffleNarrow = bloom_filters::Split64BitShuffleCandidate<1>;
using Split64BitShuffleWide = bloom_filters::Split64BitShuffleCandidate<2>;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(Split64Original, uint64_t); \
 ADD(Split64BitShuffleHybrid, uint64_t); \
 ADD(Split64BitShuffleNarrow, uint64_t); \
 ADD(Split64BitShuffleWide, uint64_t)
