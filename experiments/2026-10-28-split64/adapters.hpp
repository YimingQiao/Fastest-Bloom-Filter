#pragma once
#include "split64.hpp"
#include "../../benchmarks/boost-external/adapters.hpp"
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD)                                                                              \
	ADD(Split64P0, uint64_t);                                                                           \
	ADD(Split64P16, uint64_t);                                                                          \
	ADD(Split64P32, uint64_t);                                                                          \
	ADD(Split64P64, uint64_t);                                                                          \
	ADD(Boost192Multi64K8, uint64_t)
