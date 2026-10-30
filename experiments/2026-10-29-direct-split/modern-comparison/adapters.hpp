#pragma once
#include "../direct_split.hpp"
#include "snapshot/cpp_adapters.hpp"
#include "snapshot/rocks_adapters.hpp"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
using ByteSplit128SingleExperiment = direct_split_experiment::SingleShortcut<direct_split_experiment::ByteSplit128>;
using IndependentSplit32SingleExperiment = direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>;
using FastFilterFixed16SingleControl = direct_split_experiment::SingleShortcut<FastFilterFixed16>;
using FastFilterSimdBlockSingleControl = direct_split_experiment::SingleShortcut<FastFilterSimdBlock>;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
	ADD(ByteSplit128SingleExperiment, uint64_t); \
	ADD(IndependentSplit32SingleExperiment, uint64_t); \
	ADD(FastFilterFixed16, uint64_t); \
	ADD(FastFilterFixed16SingleControl, uint64_t); \
	ADD(FastFilterSimdBlock, uint64_t); \
	ADD(FastFilterSimdBlockSingleControl, uint64_t); \
	ADD(FastFilterFixed32, uint64_t); \
	ADD(FourSectorBloomFilter, uint64_t); \
	ADD(Split64BloomFilter, uint64_t); \
	BF_REGISTER_ROCKSDB_FILTERS(ADD)
