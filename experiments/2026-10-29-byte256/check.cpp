#include "byte256.hpp"
#include <algorithm>
#include <iostream>
#include <stdexcept>

static void require(bool condition) { if (!condition) throw std::runtime_error("byte256 oracle mismatch"); }
static std::array<uint8_t, 32> oracle_mask(uint64_t h) {
    constexpr int salts[16] = {0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
                              0x3c6f, 0x9e37, 0xb529, 0x85eb, 0x1657, 0xc2b3, 0xd1b5, 0x7f4b};
    std::array<uint8_t, 32> answer {};
    for (unsigned lane = 0; lane < 16; ++lane) {
        int64_t word = (h >> (16 * (lane % 2))) & 0xffff;
        if (word >= 32768) word -= 65536;
        int64_t multiplier = salts[lane];
        if (multiplier >= 32768) multiplier -= 65536;
        int64_t product = word * multiplier;
        int64_t high = product >= 0 ? product / 65536 : -((-product + 65535) / 65536);
        const unsigned encoded = unsigned(high) & 65535;
        for (unsigned byte = 0; byte < 2; ++byte) {
            unsigned control = (encoded >> (8 * byte)) & 255;
            if (control < 128) answer[lane * 2 + byte] = uint8_t(1u << (7 - (control % 8)));
        }
    }
    return answer;
}
static void oracle_add(std::vector<uint8_t> &bitmap, uint64_t h) {
    size_t base = ((h >> 32) & (bitmap.size() / 32 - 1)) * 32;
    auto mask = oracle_mask(h);
    for (size_t b = 0; b < 32; ++b) bitmap[base + b] |= mask[b];
}
static uint32_t oracle_query(const std::vector<uint8_t> &bitmap, uint64_t h) {
    size_t base = ((h >> 32) & (bitmap.size() / 32 - 1)) * 32;
    auto mask = oracle_mask(h);
    for (size_t b = 0; b < 32; ++b) if ((bitmap[base + b] & mask[b]) != mask[b]) return 0;
    return 1;
}
int main() {
    uint64_t checksum = 0;
    for (uint64_t i = 0; i < 65536; ++i) {
        // Both signed source halves traverse all 16-bit values, in different orders.
        uint64_t h = ((i * 40503u & 65535u) << 16) | i;
        ByteSplit256Experiment f(1, 8);
        f.Insert(1, &h);
        auto expected = oracle_mask(h);
        require(std::equal(expected.begin(), expected.end(), f.Data()));
        unsigned high_probes = 0;
        for (size_t j = 1; j < expected.size(); j += 2) high_probes += expected[j] != 0;
        require(high_probes >= 8);
    }
    // Enumerated source halves above become zero together. Cover exactly one
    // zero half independently, plus extreme signed words and nonzero addresses.
    for (uint64_t h : {0ULL, 1ULL, 0x00010000ULL, 0x00008000ULL, 0x80000000ULL,
                       0x0000ffffULL, 0xffff0000ULL, 0x80008000ULL,
                       0x000000030000ffffULL, 0xffffffffffffffffULL}) {
        ByteSplit256Experiment f(1, 8);
        std::vector<uint8_t> reference(f.SizeInBytes());
        oracle_add(reference, h);
        f.Insert(1, &h);
        require(std::equal(reference.begin(), reference.end(), f.Data()));
        const auto mask = oracle_mask(h);
        unsigned high_probes = 0;
        for (size_t j = 1; j < mask.size(); j += 2) high_probes += mask[j] != 0;
        const unsigned zeros = (uint16_t(h) == 0) + (uint16_t(h >> 16) == 0);
        require(high_probes == 8 + 4 * zeros);
    }
    for (size_t n : {size_t(0), size_t(1), size_t(17), size_t(1024), size_t(8192)}) {
        for (uint32_t bpk : {4u, 8u, 16u}) {
            for (bool collide : {false, true}) {
                ByteSplit256Experiment f(n, bpk);
                std::vector<uint8_t> reference(f.SizeInBytes());
                std::vector<uint64_t> inserted(n);
                for (size_t i = 0; i < n; ++i) {
                    inserted[i] = bloom_filters::MurmurHash64(i + 731);
                    if (collide) inserted[i] &= UINT32_MAX;
                    oracle_add(reference, inserted[i]);
                }
                f.Insert(uint32_t(n), inserted.data());
                f.Insert(uint32_t(n), inserted.data());
                require(std::equal(reference.begin(), reference.end(), f.Data()));
                require(f.Lookup(0, nullptr, nullptr) == 0);
                f.Insert(0, nullptr);
                for (size_t count = 0; count <= 131; ++count) {
                    for (size_t offset : {size_t(0), size_t(1), size_t(3)}) {
                        std::vector<uint64_t> input(offset + count);
                        for (size_t i = 0; i < count; ++i)
                            input[offset + i] = bloom_filters::MurmurHash64(1000000 + i);
                        if (n) for (size_t i = 0; i < count; i += 2) input[offset + i] = inserted[i % n];
                        std::vector<uint32_t> out(count + 10, 0x5a5a5a5a);
                        require(f.Lookup(uint32_t(count), count ? input.data() + offset : nullptr, out.data() + 5) == count);
                        for (size_t i = 0; i < count; ++i) {
                            require(out[5 + i] == oracle_query(reference, input[offset + i]));
                            checksum = checksum * 1099511628211ULL ^ out[5 + i];
                        }
                        for (size_t i = 0; i < 5; ++i)
                            require(out[i] == 0x5a5a5a5a && out[count + 5 + i] == 0x5a5a5a5a);
                    }
                }
                for (auto h : inserted) { uint32_t out; f.Lookup(1, &h, &out); require(out == 1); }
                require(std::equal(reference.begin(), reference.end(), f.Data()));
            }
        }
    }
    std::cout << "byte256 oracle and tail checksum " << checksum << '\n';
}
