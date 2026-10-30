#pragma once
#define BF_FOUR_EXTERNAL_BASE 1
#define BF_FOUR_SIMD 1
#define MASK_TABLE_ENTRIES 16
#include "baseline_snapshot.h"
#include "probe_filter.h"
using FourSectorFrozen = bloom_filters::FourSectorBF<8>;
using FourSectorGroup4 = bloom_filters::FourSectorProbe<8,1>;
using FourSectorGroup8 = bloom_filters::FourSectorProbe<8,2>;
using FourSectorPrefetch = bloom_filters::FourSectorProbe<8,3>;
using FourSectorGroup4Prefetch = bloom_filters::FourSectorProbe<8,4>;
using FourSectorGroup8Prefetch = bloom_filters::FourSectorProbe<8,5>;
using FourSectorHybrid = bloom_filters::FourSectorProbe<8,6>;
using FourSectorHybridWide = bloom_filters::FourSectorProbe<8,7>;
using FourSectorHybridUnmasked = bloom_filters::FourSectorProbe<8,8>;
using FourSectorHybridWideUnmasked = bloom_filters::FourSectorProbe<8,9>;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(FourSectorFrozen,uint64_t); \
 ADD(FourSectorGroup4,uint64_t); \
 ADD(FourSectorGroup8,uint64_t); \
 ADD(FourSectorPrefetch,uint64_t); \
 ADD(FourSectorGroup4Prefetch,uint64_t); \
 ADD(FourSectorGroup8Prefetch,uint64_t); \
 ADD(FourSectorHybrid,uint64_t); \
 ADD(FourSectorHybridWide,uint64_t); \
 ADD(FourSectorHybridUnmasked,uint64_t); \
 ADD(FourSectorHybridWideUnmasked,uint64_t)
