#include "base.h"
#include "layout_detail.h"
#include <algorithm>
#include <array>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <thread>
#include <vector>
#define private public
#include "split16_bloom.h"
#undef private
#include "parallel_layout_bloom.h"

using namespace bloom_filters;
static void Require(bool ok, const char *message) {
    if (!ok) throw std::runtime_error(message);
}
// Use 64-bit arithmetic, division and modulo rather than vector wrap/shift.
static std::array<uint16_t, 8> Mask(uint64_t h) {
    constexpr uint64_t salts[] = {31192, 59170, 62203, 8684, 4635, 8962, 28762, 28295};
    std::array<uint16_t, 8> result {};
    for (unsigned j = 0; j < 8; ++j)
        result[j] = uint16_t(uint64_t{1} << (((h % 65536) * salts[j] % 65536) / 4096));
    return result;
}
struct Reference {
    std::vector<uint16_t> words;
    explicit Reference(size_t bytes) : words(bytes / 2) {}
    size_t Offset(uint64_t h) const { return (h / (uint64_t{1} << 32) % (words.size() / 8)) * 8; }
    void Insert(uint64_t h) {
        const auto m = Mask(h);
        for (size_t j = 0; j < 8; ++j) words[Offset(h) + j] |= m[j];
    }
    uint32_t Lookup(uint64_t h) const {
        const auto m = Mask(h);
        for (size_t j = 0; j < 8; ++j)
            if ((words[Offset(h) + j] & m[j]) != m[j]) return 0;
        return 1;
    }
};
int main() {
    for (uint64_t h = 0; h < 65536; ++h) {
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON)
        std::array<uint16_t, 8> actual {};
        vst1q_u16(actual.data(), Split16BloomFilter::Mask(h));
        Require(actual == Mask(h), "exhaustive NEON mask parity");
#endif
    }
    uint64_t checksum = 14695981039346656037ULL;
    for (size_t capacity : {size_t{0}, size_t{1}, size_t{65539}, size_t{1} << 20, size_t{1} << 22}) {
        for (uint32_t bpk : {4u, 8u, 16u}) {
            const size_t n = capacity ? 65539 : 0;
            std::vector<uint64_t> keys(n), query(131081);
            for (size_t i = 0; i < n; ++i)
                keys[i] = i % 3 ? MurmurHash64(i + 731)
                               : (uint64_t(i % 4) << 32) | uint32_t(MurmurHash64(i / 7));
            if (n) { keys[0] = 0; keys[1] = UINT64_MAX; keys[2] = 0xffffffff00000000ULL; }
            for (size_t i = 0; i < query.size(); ++i)
                query[i] = i < n ? keys[i] : MurmurHash64(i + 1000000007);
            Split16BloomFilter filter(capacity, bpk);
            Reference ref(filter.SizeInBytes());
            Require(filter.SizeInBytes() == layout_detail::WordCount(capacity, bpk) * 4, "payload bytes");
            Require(reinterpret_cast<uintptr_t>(filter.lines_.data()) % 64 == 0, "alignment");
            filter.Insert(0, nullptr);
            Require(filter.Lookup(0, nullptr, nullptr) == 0, "empty lookup");
            for (uint64_t h : keys) {
                ref.Insert(h);
                Require(filter.CacheLineIndex(h) == ref.Offset(h) / 32, "physical ownership");
            }
            for (size_t i = 0; i < n; i += 31)
                filter.Insert(std::min(size_t{31}, n - i), keys.data() + i);
            Require(std::memcmp(filter.lines_.data(), ref.words.data(), filter.SizeInBytes()) == 0, "bitmap parity");
            filter.Insert(n, keys.data());
            Require(std::memcmp(filter.lines_.data(), ref.words.data(), filter.SizeInBytes()) == 0, "duplicate insertion");
            std::vector<uint32_t> expected(query.size()), out(query.size());
            for (size_t i = 0; i < query.size(); ++i) expected[i] = ref.Lookup(query[i]);
            for (size_t i = 0; i < n; ++i) Require(expected[i] == 1, "reference false negative");
            filter.Lookup(query.size(), query.data(), out.data());
            Require(out == expected, "full query parity");
            for (auto x : out) checksum = (checksum ^ x) * 1099511628211ULL;
            for (size_t offset = 0; offset < 8; ++offset) {
                for (size_t count = 0; count <= 145; ++count) {
                    std::vector<uint64_t> tail(query.begin(), query.begin() + count + offset);
                    std::vector<uint32_t> guarded(count + 2, 0xdeadbeef);
                    filter.Lookup(count, tail.data() + offset, guarded.data() + 1);
                    Require(guarded.front() == 0xdeadbeef && guarded.back() == 0xdeadbeef, "output guard");
                    for (size_t i = 0; i < count; ++i) Require(guarded[i + 1] == expected[i + offset], "tail parity");
                }
            }
            auto copy = filter;
            Require(copy.lines_.data() != filter.lines_.data(), "copy ownership");
            std::vector<uint32_t> other(query.size());
            std::thread reader([&] { copy.Lookup(query.size(), query.data(), other.data()); });
            filter.Lookup(query.size(), query.data(), out.data());
            reader.join();
            Require(out == expected && other == expected, "concurrent immutable readers");
            for (size_t workers : {1u, 2u, 3u, 7u}) {
                ParallelSplit16BloomFilter parallel(capacity, bpk);
                parallel.InsertParallel(n, keys.data(), workers);
                parallel.InsertParallel(n, keys.data(), workers);
                parallel.LookupParallel(query.size(), query.data(), out.data(), workers);
                Require(out == expected, "parallel construction/query parity");
            }
        }
    }
    for (const auto size : {std::pair<size_t, uint32_t>{1, 0}, {SIZE_MAX, 8}, {size_t{1} << 28, 8}}) {
        bool rejected = false;
        try { Split16BloomFilter invalid(size.first, size.second); }
        catch (const std::exception &) { rejected = true; }
        Require(rejected, "invalid size accepted");
    }
    std::cout << "Split16 exhaustive masks, bitmaps, collisions, tails, copies and parallel parity passed: " << checksum << '\n';
}
