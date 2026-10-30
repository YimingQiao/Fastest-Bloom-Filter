#pragma once
// Additive correctness preparation. No source in the passed parent is modified.
#include "../vldb-original-external/compat.hpp"
#include <dtl/filter/blocked_bloomfilter/block_addressing_logic.hpp>
#include <cstdint>
#include <limits>
#include <stdexcept>

namespace vldb_stage2 {
struct Geometry {
  size_t budget_bytes, constructor_bits, logical_bytes, backing_bytes;
  uint32_t block_bytes, block_count;
  dtl::block_addressing address;
};
inline bool Power2(size_t x) { return x && !(x & (x - 1)); }
inline size_t Round64(size_t x) {
  if (x > SIZE_MAX - 63) throw std::overflow_error("bitmap rounding");
  return (x + 63) & ~size_t(63);
}
// Preserve the public constructor's automatic POWER_OF_TWO/MAGIC choice.
// MAGIC rounds up to a cheap divisor, so request the greatest such divisor
// whose *rounded backing allocation* fits the cap, not the cap itself.
inline Geometry Plan(size_t budget_bytes, uint32_t block_bytes) {
  if (!Power2(block_bytes) || block_bytes < 8 || block_bytes > 64 ||
      budget_bytes < 128 || budget_bytes > (size_t{1} << 28))
    throw std::invalid_argument("stage2 geometry outside checked range");
  const size_t cap = budget_bytes / 64 * 64;
  uint32_t count = static_cast<uint32_t>(cap / block_bytes);
  dtl::block_addressing address = dtl::block_addressing::POWER_OF_TWO;
  if (!Power2(cap)) {
    address = dtl::block_addressing::MAGIC;
    // next_cheap_magic is nondecreasing. No hand-written substitute for the
    // original divisor algorithm is used by the filter or the planner.
    uint32_t lo = 2, hi = count, best = 0;
    while (lo <= hi) {
      const uint32_t mid = lo + (hi - lo) / 2;
      const auto candidate = dtl::next_cheap_magic(mid).divisor;
      if (Round64(size_t(candidate) * block_bytes) <= cap) {
        best = candidate;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    if (!best) throw std::invalid_argument("no fitting MAGIC block count");
    count = best;
  }
  const size_t logical = size_t(count) * block_bytes;
  if (Power2(logical) != (address == dtl::block_addressing::POWER_OF_TWO) ||
      Round64(logical) > budget_bytes)
    throw std::runtime_error("planner mode or allocation invariant");
  return {budget_bytes, logical * 8, logical, Round64(logical), block_bytes, count, address};
}
inline const char* AddressName(dtl::block_addressing address) {
  return address == dtl::block_addressing::POWER_OF_TWO ? "pow2" : "magic";
}
} // namespace vldb_stage2
