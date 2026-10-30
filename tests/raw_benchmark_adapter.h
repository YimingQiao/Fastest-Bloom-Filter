#pragma once
#include "fast_pattern_BF.h"
#include <vector>
// Test adapter whose raw-key API applies exactly the common source hash. Its
// complete answers must match the prehashed path: this catches double hashing.
class RawFastPatternFixture {
public:
    static constexpr bool kRawKeyApi = true;
    RawFastPatternFixture(size_t n, uint32_t bpk) : filter(n, bpk) {}
    size_t SizeInBytes() const { return filter.SizeInBytes(); }
    void Insert(uint32_t n, const uint64_t* raw) {
        std::vector<uint64_t> hashes(n);
        bloom_filters::HashVector(n, raw, hashes.data());
        filter.Insert(n, hashes.data());
    }
    void Lookup(uint32_t n, const uint64_t* raw, uint32_t* out) {
        std::vector<uint64_t> hashes(n);
        bloom_filters::HashVector(n, raw, hashes.data());
        filter.Lookup(n, hashes.data(), out);
    }
private:
    bloom_filters::FastPatternBF filter;
};
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) ADD(RawFastPatternFixture, uint64_t)
