#pragma once
#include "../../benchmarks/vldb-raw32-stage2/geometry.hpp"
#include <optional>

namespace vldb_nearby {
using Geometry = vldb_stage2::Geometry;
inline uint32_t Maximum(size_t budget, uint32_t block) {
    if ((block != 8 && block != 32 && block != 64) || budget < 128 ||
        budget > (size_t{1} << 28))
        throw std::invalid_argument("nearby geometry outside frozen domain");
    return static_cast<uint32_t>((budget / 64 * 64) / block);
}
inline uint32_t Lower(uint32_t maximum) {
    return static_cast<uint32_t>(std::max<uint64_t>(3, (uint64_t{99} * maximum + 99) / 100));
}
// Exactly one source-only rule: largest accepted odd cheap divisor in the top
// one percent of fitting block counts. Failure stays unsupported, never falls
// back to a larger window or a different rule.
inline std::optional<Geometry> Plan(size_t budget, uint32_t block) {
    const uint32_t maximum = Maximum(budget, block), lower = Lower(maximum);
    uint32_t candidate = maximum | 1u;
    if (candidate > maximum) candidate -= 2;
    while (candidate >= lower) {
        if (dtl::next_cheap_magic(candidate).divisor == candidate) {
            const size_t logical = size_t(candidate) * block;
            const size_t backing = vldb_stage2::Round64(logical);
            if (backing <= budget / 64 * 64)
                return Geometry{budget, logical * 8, logical, backing, block,
                                candidate, dtl::block_addressing::MAGIC};
        }
        if (candidate < lower + 2) break;
        candidate -= 2;
    }
    return std::nullopt;
}
// Independent enumeration validates maximality without changing the chosen
// constructor argument or the original address algorithm.
inline void Check(const Geometry& geometry) {
    const uint32_t maximum = Maximum(geometry.budget_bytes, geometry.block_bytes);
    const uint32_t lower = Lower(maximum), count = geometry.block_count;
    if (!(count & 1) || count < lower || count > maximum ||
        dtl::next_cheap_magic(count).divisor != count ||
        geometry.address != dtl::block_addressing::MAGIC ||
        geometry.logical_bytes != size_t(count) * geometry.block_bytes ||
        geometry.constructor_bits != geometry.logical_bytes * 8 ||
        geometry.backing_bytes != vldb_stage2::Round64(geometry.logical_bytes) ||
        geometry.backing_bytes > geometry.budget_bytes / 64 * 64)
        throw std::logic_error("nearby geometry violates the fixed rule");
    for (uint32_t larger = count + 2; larger <= maximum; larger += 2)
        if (dtl::next_cheap_magic(larger).divisor == larger)
            throw std::logic_error("nearby rule left a larger accepted odd divisor");
}
} // namespace vldb_nearby
