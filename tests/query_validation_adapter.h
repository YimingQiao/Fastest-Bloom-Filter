#pragma once
#include "fast_pattern_BF.h"

// Deliberately corrupt exactly one complete-query pass after the correct warm-up.
// The regression uses n=1024, q=batch=4096: construction validation never counts
// as a query pass, warm-up is pass 1, prehashed timing pass 2, hash timing pass 3.
template <unsigned FailAt>
class TimedOutputFaultFixture {
	bloom_filters::FastPatternBF filter_;
	unsigned query_passes_ = 0;

public:
	TimedOutputFaultFixture(size_t n, uint32_t bpk) : filter_(n, bpk) {
	}
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	void Insert(uint32_t n, const uint64_t *hashes) {
		filter_.Insert(n, hashes);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) {
		filter_.Lookup(n, hashes, out);
		if (n == 4096 && ++query_passes_ == FailAt)
			out[n - 1] ^= 1;
		return n;
	}
};
using FaultOnPrehashedFixture = TimedOutputFaultFixture<2>;
using FaultOnHashLookupFixture = TimedOutputFaultFixture<3>;
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
	ADD(FaultOnPrehashedFixture, uint64_t); \
	ADD(FaultOnHashLookupFixture, uint64_t)
