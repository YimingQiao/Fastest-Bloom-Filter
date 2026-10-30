#pragma once
#define BF_FOUR_EXTERNAL_BASE 1
#define BF_FOUR_SIMD          1
#define MASK_TABLE_ENTRIES    16
#include "four_sector.h"
#include "../2026-10-28-split64/split64.hpp"
#include "../../benchmarks/boost-external/adapters.hpp"
using FourSector16K8 = bloom_filters::FourSectorBF<8>;
using FourSector16K9 = bloom_filters::FourSectorBF<9>;
using FourSector16K10 = bloom_filters::FourSectorBF<10>;
using FourSector16K12 = bloom_filters::FourSectorBF<12>;
using FourSector16K8ScalarBuild = bloom_filters::FourSectorBF<8, false>;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD)                                                                              \
	ADD(FourSector16K8, uint64_t);                                                                                     \
	ADD(FourSector16K9, uint64_t);                                                                                     \
	ADD(FourSector16K10, uint64_t);                                                                                    \
	ADD(FourSector16K12, uint64_t);                                                                                    \
	ADD(FourSector16K8ScalarBuild, uint64_t);                                                                          \
	ADD(Split64P32, uint64_t);                                                                                         \
	ADD(Boost192Multi64K8, uint64_t)
