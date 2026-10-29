#pragma once
#include <climits>
#include <cstring>
#include <vector>
// The unchanged upstream header expects this name in its including scope.
using std::vector;
#include "bloom/simd-block-fixed-fpp.h"

// Upstream's AArch64 SimdBlockFilterFixed is an eight-u16-sector NEON
// filter, distinct from its x86 Fixed16 byte mask. Its ARM AddAll is only
// declared, so this adapter calls the available public Add/Find API.
class FastFilterArm16 {
    SimdBlockFilterFixed<boost_baseline::IdentityHash> filter_;
public:
    FastFilterArm16(size_t n, uint32_t bpk)
        : filter_(static_cast<int>(boost_baseline::requested_bits(n, bpk) / 128 * 10)) {}
    FastFilterArm16(const FastFilterArm16&) = delete;
    FastFilterArm16(FastFilterArm16&&) = delete;
    size_t SizeInBytes() const { return filter_.SizeInBytes(); }
    void Insert(uint32_t n, const uint64_t* h) {
        for (size_t i = 0; i < n; ++i) filter_.Add(h[i]);
    }
    uint32_t Lookup(uint32_t n, const uint64_t* h, uint32_t* out) const {
        for (size_t i = 0; i < n; ++i) out[i] = filter_.Find(h[i]);
        return n;
    }
};
