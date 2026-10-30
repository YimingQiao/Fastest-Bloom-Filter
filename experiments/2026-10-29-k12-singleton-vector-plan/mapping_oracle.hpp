#pragma once
#include <array>
#include <cstdint>

namespace k12_singleton_oracle {
struct Probe {
    uint32_t line;
    std::array<uint32_t, 4> local;
    std::array<uint32_t, 4> masks;
};

// Bit positions spell out the existing fixed three-bit dictionary independently
// of the production word constants and SIMD table-selection implementation.
inline Probe MakeProbe(uint64_t hash, uint32_t line_count) {
    constexpr uint32_t positions[16][3] = {
        {0,1,3}, {0,4,9}, {0,6,13}, {0,8,18},
        {0,1,12}, {0,2,15}, {0,4,16}, {0,3,8},
        {0,6,15}, {0,7,18}, {0,1,10}, {0,2,5},
        {0,4,10}, {0,7,15}, {0,1,13}, {0,3,14}
    };
    Probe result{};
    result.line = static_cast<uint32_t>(((hash >> 40) * line_count) >> 24);
    const uint32_t high = static_cast<uint32_t>(hash >> 32);
    const uint32_t low = static_cast<uint32_t>(hash);
    for (unsigned sector = 0; sector < 4; ++sector) {
        // Ordinary C++ uint32_t >> 32 would be undefined. Model SIMD lane0's
        // VPSRLVD count32 result with an explicit zero, not a scalar shift32.
        const uint32_t extra = sector == 0 ? 0 : ((high >> (sector * 2)) & 3);
        result.local[sector] = sector * 4 + ((high & 3) ^ extra);
        const unsigned rotate = sector * 8;
        const uint32_t code = (low >> rotate) | (low << ((32 - rotate) & 31));
        // VPERMD selects by low4 bits. VPROLVD rotates by low5 shift bits.
        const uint32_t dictionary = code & 15;
        const uint32_t shift = (code >> 4) & 31;
        for (unsigned bit : positions[dictionary])
            result.masks[sector] |= uint32_t{1} << ((bit + shift) & 31);
    }
    return result;
}

inline bool Contains(const uint32_t* words, uint32_t line_count, uint64_t hash) {
    const auto expected = MakeProbe(hash, line_count);
    bool found = true;
    for (unsigned sector = 0; sector < 4; ++sector) {
        const uint64_t index = uint64_t{expected.line} * 16 + expected.local[sector];
        found &= (words[index] & expected.masks[sector]) == expected.masks[sector];
    }
    return found;
}
} // namespace k12_singleton_oracle
