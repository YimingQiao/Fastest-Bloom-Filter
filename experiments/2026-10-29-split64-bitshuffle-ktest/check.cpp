#include "adapters.hpp"
#if defined(BF_EXPECT_BITALG) && !defined(__AVX512BITALG__)
#error "Minimum BITALG test must exercise the candidate instruction path"
#endif
#include <array>
#include <cstring>
#include <iostream>
#include <stdexcept>

static void require(bool value) {
    if (!value) throw std::runtime_error("Split64 direct-bit oracle mismatch");
}
static constexpr std::array<uint64_t, 8> salts = {
    0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d,
    0x705495c7, 0x2df1424b, 0x9efc4947, 0x5c6bfb31
};
static size_t block(uint64_t h, size_t bytes) { return (h / (uint64_t(1) << 32)) % (bytes / 64); }
static unsigned position(uint64_t h, unsigned j) {
    return ((h % (uint64_t(1) << 32)) * salts[j] % (uint64_t(1) << 32)) / (uint64_t(1) << 26);
}
static void add(std::vector<uint8_t> &bitmap, uint64_t h) {
    for (unsigned j = 0; j < 8; ++j) {
        const auto bit = position(h, j);
        bitmap[block(h, bitmap.size()) * 64 + j * 8 + bit / 8] |= 1u << (bit % 8);
    }
}
static uint32_t query(const std::vector<uint8_t> &bitmap, uint64_t h) {
    for (unsigned j = 0; j < 8; ++j) {
        const auto bit = position(h, j);
        if (!(bitmap[block(h, bitmap.size()) * 64 + j * 8 + bit / 8] & (1u << (bit % 8)))) return 0;
    }
    return 1;
}

template<class BF> static uint64_t check() {
    uint64_t checksum = 0;
    // Prove every sector's selected bit matters, while unrelated bits cannot
    // mask a missing probe. The test-only view is a mutable allocation underneath.
    BF controlled(1, 8);
    bool covered[8][64] {};
    for (uint64_t i = 0; i < 1024; ++i) {
        const auto h = bloom_filters::MurmurHash64(i + 9001);
        std::vector<uint8_t> exact(controlled.SizeInBytes());
        add(exact, h);
        std::memcpy(const_cast<uint8_t *>(controlled.Data()), exact.data(), exact.size());
        uint32_t out = 9;
        controlled.Lookup(1, &h, &out);
        require(out == 1);
        for (unsigned lane = 0; lane < 8; ++lane) {
            std::vector<uint8_t> dense(exact.size(), 255);
            const auto bit = position(h, lane);
            covered[lane][bit] = true;
            dense[block(h, dense.size()) * 64 + lane * 8 + bit / 8] &= ~(1u << (bit % 8));
            std::memcpy(const_cast<uint8_t *>(controlled.Data()), dense.data(), dense.size());
            controlled.Lookup(1, &h, &out);
            require(out == 0);
        }
    }
    for (const auto &sector : covered)
        require(std::all_of(std::begin(sector), std::end(sector), [](bool seen) { return seen; }));
    for (size_t n : {size_t(0), size_t(1), size_t(17), size_t(1024), size_t(8192)}) {
        for (uint32_t bpk : {4u, 8u, 16u}) {
            for (bool collisions : {false, true}) {
                BF f(n, bpk);
                std::vector<uint8_t> bitmap(f.SizeInBytes());
                std::vector<uint64_t> inserted(n);
                for (size_t i = 0; i < n; ++i) {
                    inserted[i] = bloom_filters::MurmurHash64(i + 721);
                    if (collisions) inserted[i] &= UINT32_MAX;
                    add(bitmap, inserted[i]);
                }
                f.Insert(n, inserted.data());
                f.Insert(n, inserted.data());
                require(std::equal(bitmap.begin(), bitmap.end(), f.Data()));
                f.Insert(0, nullptr);
                require(f.Lookup(0, nullptr, nullptr) == 0);
                for (const auto h : inserted) {
                    uint32_t out = 9;
                    f.Lookup(1, &h, &out);
                    require(out == 1);
                }
                for (size_t length : {size_t(0), size_t(1), size_t(3), size_t(4), size_t(7), size_t(8), size_t(15),
                                      size_t(16), size_t(31), size_t(32), size_t(63), size_t(64), size_t(127),
                                      size_t(128), size_t(131), size_t(4096), size_t(4097), size_t(4127)}) {
                    for (size_t offset = 0; offset < 8; ++offset) {
                        std::vector<uint64_t> input(length + offset);
                        std::vector<uint32_t> output(length + 8, 0x53535353);
                        for (size_t i = 0; i < length; ++i)
                            input[offset+i] = bloom_filters::MurmurHash64(i + 1000000);
                        // Keep the positive fill separate: this avoids the known
                        // Clang23 predicated-gather bug in the mixed ternary fixture.
                        if (n) for (size_t i = 1; i < length; i += 2)
                            input[offset+i] = inserted[i % n];
                        require(f.Lookup(length, length ? input.data() + offset : nullptr, output.data() + 4) == length);
                        for (size_t i = 0; i < length; ++i) {
                            require(output[4+i] == query(bitmap, input[offset+i]));
                            checksum = checksum * 1099511628211ULL ^ output[4+i];
                        }
                        for (size_t i = 0; i < 4; ++i)
                            require(output[i] == 0x53535353 && output[length+4+i] == 0x53535353);
                    }
                }
                require(std::equal(bitmap.begin(), bitmap.end(), f.Data()));
            }
        }
    }
    return checksum;
}
int main() {
#if defined(__AVX512BITALG__)
    constexpr __mmask64 selected = 0x0101010101010101ULL;
    require(_ktestc_mask64_u8(selected, selected) == 1);
    require(_ktestc_mask64_u8(~__mmask64{0}, selected) == 1);
    require(_ktestc_mask64_u8(0, selected) == 0);
    for (unsigned lane = 0; lane < 8; ++lane)
        require(_ktestc_mask64_u8(selected & ~(__mmask64{1} << (8 * lane)), selected) == 0);
#endif
    const auto original = check<Split64Original>();
    require(check<Split64BitShuffleHybrid>() == original);
    require(check<Split64BitShuffleNarrow>() == original);
    require(check<Split64BitShuffleWide>() == original);
    require(check<Split64BitShuffleHybridKtest>() == original);
    std::cout << "Split64 bitmap/oracle/bit-selection/tail checksum " << original << '\n';
}
