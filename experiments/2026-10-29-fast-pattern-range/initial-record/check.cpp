#include "fast_pattern_range.h"
#include "oracle_tables.hpp"
#include <array>
#include <cstring>
#include <iostream>
#include <numeric>

using Filter = bloom_filters::FastPatternRange;
using Budget = bloom_filters::FastPatternRangeBytes;
static uint64_t digest = 14695981039346656037ULL;
static void Require(bool value, const char *why) { if (!value) throw std::runtime_error(why); }
template<class Fn> static void Rejects(Fn fn) {
    bool rejected = false;
    try { fn(); } catch (const std::exception &) { rejected = true; }
    Require(rejected, "invalid budget accepted");
}
static uint64_t Next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
struct Oracle {
    std::vector<uint32_t> words;
    const uint32_t *table;
    Oracle(size_t bytes, size_t actual_keys) : words(bytes / 4), table(actual_keys > bytes * 8 / 12
        ? pattern_range_oracle::sparse_patterns_ : pattern_range_oracle::dense_patterns_) {}
    static uint32_t Rotate(uint32_t value, unsigned distance) {
        distance %= 32;
        if (!distance) return value;
        return (uint64_t(value) << distance) | (value >> (32 - distance));
    }
    std::array<uint32_t, 4> Probe(uint64_t h) const {
        // Division and modulo deliberately express the scalar model without
        // calling candidate index/mask/rotation helpers or SIMD intrinsics.
        const uint64_t hi = h / (uint64_t{1} << 32);
        const uint32_t lo = uint32_t(h);
        const size_t a = (hi * words.size()) / (uint64_t{1} << 32);
        const size_t b = a ^ (8 + ((lo / (1u << 20)) % 8));
        Require(a < words.size() && b < words.size() && a / 16 == b / 16 && a != b, "oracle line ownership");
        const uint32_t first = Rotate(table[lo % 32], (lo / 32) % 32);
        const uint32_t code = lo / 1024;
        const uint32_t second = Rotate(table[code % 32], (code / 32) % 32);
        return {uint32_t(a), uint32_t(b), first, second};
    }
    void Insert(uint64_t h) { const auto p = Probe(h); words[p[0]] |= p[2]; words[p[1]] |= p[3]; }
    uint32_t Lookup(uint64_t h) const {
        const auto p = Probe(h);
        return (words[p[0]] & p[2]) == p[2] && (words[p[1]] & p[3]) == p[3];
    }
};
static void Mix(uint32_t value) { digest = (digest ^ value) * 1099511628211ULL; }
static void Case(size_t lines, bool sparse) {
    const size_t bytes = lines * 64, real_n = bytes * 8 / 12 + unsigned(sparse);
    Filter filter(real_n, Budget{bytes + 31});
    Require(filter.SizeInBytes() == bytes && filter.LogicalBytes() == bytes, "charged capacity mismatch");
    Require(uintptr_t(filter.Data()) % 64 == 0, "bitmap base not64-byte aligned");
    Require(filter.NumProbes() == (sparse ? 6 : 8), "real-n density threshold changed");
    Oracle oracle(bytes, real_n);
    uint64_t state = 0x1020304050607080ULL + lines;
    std::vector<uint64_t> keys;
    for (size_t i = 0; i < std::min<size_t>(4096, lines * 8); ++i) keys.push_back(Next(state));
    for (unsigned bit = 0; bit < 64; ++bit) {
        keys.push_back(uint64_t{1} << bit);
        keys.push_back(~(uint64_t{1} << bit));
    }
    // Include source states immediately below/at/above representative reducer
    // bucket boundaries, including unsigned values above2^31.
    const uint64_t words = bytes / 4;
    for (uint64_t bucket : {uint64_t{0},uint64_t{1},words/2,words-1,words}) {
        const uint64_t boundary = (bucket * (uint64_t{1} << 32) + words - 1) / words;
        for (int delta : {-1,0,1}) {
            if ((delta < 0 && !boundary) || boundary + delta > UINT32_MAX) continue;
            keys.push_back(((boundary + delta) << 32) | uint32_t(Next(state)));
        }
    }
    keys.push_back(0); keys.push_back(UINT64_MAX);
    for (size_t start = 0; start < keys.size(); start += 37) {
        const size_t count = std::min<size_t>(37, keys.size() - start);
        filter.Insert(count, keys.data() + start);
        for (size_t i = 0; i < count; ++i) oracle.Insert(keys[start + i]);
        Require(std::memcmp(filter.Data(), oracle.words.data(), bytes) == 0, "full insertion bitmap differs");
    }
    filter.Insert(keys.size(), keys.data());
    Require(std::memcmp(filter.Data(), oracle.words.data(), bytes) == 0, "duplicate insert changed bitmap");
    for (uint64_t h : keys) { uint32_t out = 9; filter.Lookup(1,&h,&out); Require(out == 1, "false negative"); }
    std::vector<uint64_t> queries(4200);
    for (auto &h : queries) h = Next(state);
    for (size_t i = 1; i < queries.size(); i += 2) queries[i] = keys[i % keys.size()];
    for (size_t count = 0; count <= 131; ++count) {
        for (size_t offset : {size_t{0},size_t{1},size_t{7}}) {
            std::vector<uint32_t> output(count + 2,0xfeed1234);
            Require(filter.Lookup(count,queries.data()+offset,output.data()+1) == count, "return count");
            Require(output.front() == 0xfeed1234 && output.back() == 0xfeed1234, "short output guard");
            for (size_t i=0; i<count; ++i) { Require(output[i+1] == oracle.Lookup(queries[offset+i]), "short answer"); Mix(output[i+1]); }
        }
    }
    for (size_t count : {size_t{4096},size_t{4097},size_t{4127}}) {
        std::vector<uint32_t> output(count + 2,0xfeed1234);
        filter.Lookup(count,queries.data()+7,output.data()+1);
        Require(output.front() == 0xfeed1234 && output.back() == 0xfeed1234, "long output guard");
        for (size_t i=0; i<count; ++i) { Require(output[i+1] == oracle.Lookup(queries[i+7]), "long answer"); Mix(output[i+1]); }
    }
    filter.Insert(0,nullptr);
    Require(filter.Lookup(0,nullptr,nullptr) == 0, "empty lookup");
    for (uint32_t word : oracle.words) Mix(word);
}
static void RequiredBits() {
    constexpr size_t bytes = 3 * 64;
    for (bool sparse : {false,true}) {
        const size_t real_n = bytes * 8 / 12 + unsigned(sparse);
        for (uint32_t code = 0; code < 1024; ++code) {
            Filter filter(real_n,Budget{bytes});
            Oracle oracle(bytes,real_n);
            const uint64_t h = (uint64_t(uint32_t(0x81234567u + code * 0x12345u)) << 32)
                | code | (uint64_t(1023-code) << 10) | (uint64_t(code%8) << 20);
            filter.Insert(1,&h); oracle.Insert(h);
            Require(std::memcmp(filter.Data(),oracle.words.data(),bytes) == 0, "single-mask bitmap");
            auto *words = const_cast<uint32_t *>(static_cast<const uint32_t *>(filter.Data()));
            const auto probe = oracle.Probe(h);
            for (size_t sector = 0; sector < 2; ++sector) {
                for (unsigned bit=0; bit<32; ++bit) if (probe[sector+2] & (uint32_t{1} << bit)) {
                    words[probe[sector]] &= ~(uint32_t{1} << bit);
                    uint32_t out=9; filter.Lookup(1,&h,&out); Require(out==0,"missing required mask bit accepted");
                    words[probe[sector]] |= uint32_t{1} << bit;
                }
            }
        }
    }
}
int main() {
    try {
        for (size_t lines : {2u,3u,5u,7u,31u,257u,32767u,32768u,32769u})
            for (bool sparse : {false,true}) Case(lines,sparse);
        RequiredBits();
        Filter empty(0,Budget{128}); Require(empty.NumProbes()==8,"empty explicit capacity density");
        Rejects([] { Filter bad(100,Budget{127}); });
        Rejects([] { Filter bad(100,Budget{(size_t{1} << 28)+1}); });
        Rejects([] { Filter bad(1,0); });
        Rejects([] { Filter bad(0,16); });
        Rejects([] { Filter bad(SIZE_MAX,32); });
        std::cout << "FastPatternRange scalar-oracle/bitmap/tails passed checksum=" << digest << '\n';
    } catch (const std::exception &e) { std::cerr << e.what() << '\n'; return 1; }
}
