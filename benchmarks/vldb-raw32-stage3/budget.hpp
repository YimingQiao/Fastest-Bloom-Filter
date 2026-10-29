#pragma once
#include <algorithm>
#include <climits>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>

namespace exact_budget {
inline size_t Bytes(size_t n, uint32_t bpk) {
    if (!n || !bpk || n > SIZE_MAX / bpk)
        throw std::invalid_argument("zero or overflowing exact byte budget");
    const size_t bytes = n * bpk / 8;
    if (!bytes || bytes > (size_t{1} << 28))
        throw std::length_error("exact byte ceiling must be in 1..256 MiB");
    return bytes;
}
inline size_t AtLeast(size_t bytes, size_t minimum) {
    if (bytes < minimum) throw std::invalid_argument("budget below minimum allocation");
    return bytes;
}
inline size_t FloorUnits(size_t bytes, size_t unit) {
    return AtLeast(bytes, unit) / unit * unit;
}
inline size_t FloorPower2(size_t bytes) {
    AtLeast(bytes, 1);
    size_t answer = 1;
    while (answer <= bytes / 2) answer *= 2;
    return answer;
}
inline int FixedArgument(size_t bytes, size_t unit, size_t scale) {
    const size_t count = AtLeast(bytes, unit) / unit;
    if (count > static_cast<size_t>(INT_MAX) / scale)
        throw std::length_error("FastFilter constructor argument overflow");
    return static_cast<int>(count * scale);
}
inline size_t NativeBytes(size_t n, uint32_t legacy_bpk) {
    if (!legacy_bpk || n > SIZE_MAX / legacy_bpk)
        throw std::invalid_argument("invalid native size");
    const size_t bits = std::max<size_t>(512, n * legacy_bpk);
    if (bits >= (size_t{1} << 31)) throw std::length_error("native size overflow");
    size_t bytes = 128;
    while (bytes <= bits / 8) bytes *= 2;
    return bytes;
}
inline uint32_t NativeArgument(size_t n, size_t bytes) {
    const size_t target = FloorPower2(AtLeast(bytes, 128));
    // Smallest integral legacy bpk reaching the lower half of the target range.
    // Real n is retained, including FastPattern's real density-dependent table.
    const size_t half_bits = target * 4;
    const size_t argument = half_bits / n + (half_bits % n != 0);
    if (!argument || argument > UINT32_MAX || NativeBytes(n, argument) != target)
        throw std::invalid_argument("no native public constructor fits this ceiling");
    return static_cast<uint32_t>(argument);
}
template<unsigned K, bool Compact>
unsigned PageLevel(size_t bytes) {
    unsigned level = 8 - 8 / K;
    if constexpr (!Compact) {
        level = 12;
        for (unsigned i = 6; i < 12; ++i) {
            if (bytes < (size_t{1} << (i + 4))) {
                level = std::max(i, 8 - 8 / K);
                break;
            }
        }
    }
    while ((bytes >> level) >= (1u << 18)) ++level;
    if (level > 13 || !(bytes >> level))
        throw std::invalid_argument("unsupported PageBloom geometry");
    return level;
}
} // namespace exact_budget
