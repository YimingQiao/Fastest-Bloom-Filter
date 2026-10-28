#include "word16.hpp"
#include <algorithm>
#include <iostream>
#include <limits>
#include <stdexcept>

static void require(bool condition) { if (!condition) throw std::runtime_error("word16 oracle mismatch"); }
static std::array<uint8_t, 32> oracle_mask(uint64_t h) {
    constexpr int salts[16] = {0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
                              0x3c6f, 0x9e37, 0xb529, 0x85eb, 0x1657, 0xc2b3, 0xd1b5, 0x7f4b};
    std::array<uint8_t, 32> answer {};
    for (unsigned lane = 0; lane < 16; ++lane) {
        const uint64_t source = (h >> (16 * (lane % 2))) & 0xffff;
        const uint64_t product = source * unsigned(salts[lane]);
        const unsigned position = (product / 4096) % 16;
        answer[2 * lane + position / 8] = uint8_t(1u << (position % 8));
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
template<class Exception> static void require_rejected(size_t n, uint32_t bpk) {
    bool rejected = false;
    try { Word16Split256Experiment f(n, bpk); }
    catch (const Exception &) { rejected = true; }
    require(rejected);
}
int main() {
    require_rejected<std::invalid_argument>(0, 0);
    require_rejected<std::invalid_argument>(1, 0);
    require_rejected<std::invalid_argument>(std::numeric_limits<size_t>::max(), 8);
    require_rejected<std::invalid_argument>(std::numeric_limits<size_t>::max() / 8 + 1, 8);
    require_rejected<std::length_error>(size_t{1} << 28, 8);
    require_rejected<std::length_error>(1, uint32_t{1} << 31);
    for (const auto &test : {std::array<size_t, 2>{0, 128}, {1, 128}, {63, 128},
                            {64, 128}, {127, 128}, {128, 256}, {255, 256}, {256, 512}}) {
        Word16Split256Experiment empty(test[0], 8);
        require(empty.SizeInBytes() == test[1]);
        require(std::all_of(empty.Data(), empty.Data() + empty.SizeInBytes(), [](uint8_t b) { return b == 0; }));
        const uint64_t keys[] = {0, 1, UINT64_MAX, uint64_t{1} << 32};
        uint32_t out[4] = {9, 9, 9, 9};
        require(empty.Lookup(4, keys, out) == 4);
        require(std::all_of(out, out + 4, [](uint32_t b) { return b == 0; }));
        empty.Insert(0, nullptr);
        require(empty.Lookup(0, nullptr, nullptr) == 0);
    }
    uint64_t checksum = 0;
    for (uint64_t i = 0; i < 65536; ++i) {
        // Both source halves traverse all 16-bit values, in different orders.
        uint64_t h = ((i * 40503u & 65535u) << 16) | i;
        Word16Split256Experiment f(1, 8);
        f.Insert(1, &h);
        auto expected = oracle_mask(h);
        require(std::equal(expected.begin(), expected.end(), f.Data()));
        unsigned probes = 0;
        for (auto byte : expected) probes += __builtin_popcount(unsigned(byte));
        require(probes == 16);
    }
    // Enumerated source halves above become zero together. Cover exactly one
    // zero half independently, plus extreme words and nonzero addresses.
    for (uint64_t h : {0ULL, 1ULL, 0x00010000ULL, 0x00008000ULL, 0x80000000ULL,
                       0x0000ffffULL, 0xffff0000ULL, 0x80008000ULL,
                       0x000000030000ffffULL, 0xffffffffffffffffULL}) {
        Word16Split256Experiment f(1, 8);
        std::vector<uint8_t> reference(f.SizeInBytes());
        oracle_add(reference, h);
        f.Insert(1, &h);
        require(std::equal(reference.begin(), reference.end(), f.Data()));
    }
    for (size_t n : {size_t(0), size_t(1), size_t(17), size_t(1024), size_t(8192)}) {
        for (uint32_t bpk : {4u, 8u, 16u}) {
            for (bool collide : {false, true}) {
                Word16Split256Experiment f(n, bpk);
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
                std::vector<size_t> lengths;
                for (size_t count = 0; count <= 131; ++count) lengths.push_back(count);
                if (n == 8192 && bpk != 4)
                    for (size_t count = 4096; count <= 4127; ++count) lengths.push_back(count);
                for (size_t count : lengths) {
                    for (size_t offset = 0; offset < 8; ++offset) {
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
    std::cout << "word16 oracle and tail checksum " << checksum << '\n';
}
