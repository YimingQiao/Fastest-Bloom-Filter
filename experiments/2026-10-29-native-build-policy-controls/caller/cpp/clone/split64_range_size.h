#pragma once
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>

namespace native_clone {
struct RangeBytes { size_t bytes; };
namespace range_detail {
inline size_t LineCount(size_t bytes) {
    if (bytes < 128 || bytes > (size_t{1} << 28))
        throw std::length_error("range byte budget must be in 128..256 MiB");
    return bytes / 64;
}
inline size_t BudgetBytes(size_t n, uint32_t bpk) {
    if (!n || !bpk || n > std::numeric_limits<size_t>::max() / bpk)
        throw std::invalid_argument("zero or overflowing range budget");
    const size_t bytes = n * bpk / 8;
    (void)LineCount(bytes);
    return bytes;
}
}
}
