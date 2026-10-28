#include "parallel_independent32.h"
#include "../2026-10-29-inline-single-query/independent_vbmi_control.hpp"
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>

using Filter = bloom_filters::Independent32BloomFilter;
using Parallel = bloom_filters::ParallelIndependent32BloomFilter;
using Parent = independent_vbmi_experiment::IndependentVbmi32;

static void Require(bool ok, const char *message) {
    if (!ok) throw std::runtime_error(message);
}
static uint64_t Next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
static std::vector<uint64_t> Keys(size_t n, uint64_t seed) {
    std::vector<uint64_t> result(n);
    for (auto &h : result) h = Next(seed);
    return result;
}
// Independent scalar model. It never invokes the candidate's index or masks.
static std::vector<uint32_t> Oracle(size_t bytes, const std::vector<uint64_t> &keys) {
    std::vector<uint32_t> words(bytes / 4);
    for (uint64_t h : keys) {
        const size_t base = ((h >> 41) % (bytes / 32)) * 8;
        for (unsigned lane = 0; lane != 8; ++lane)
            words[base + lane] |= uint32_t(1) << ((h / (uint64_t(1) << (lane * 5))) % 32);
    }
    return words;
}
static uint32_t Answer(const std::vector<uint32_t> &words, uint64_t h) {
    const size_t base = ((h >> 41) % (words.size() / 8)) * 8;
    for (unsigned lane = 0; lane != 8; ++lane)
        if (!(words[base + lane] & (uint32_t(1) << ((h >> (lane * 5)) % 32)))) return 0;
    return 1;
}
static uint64_t digest = 14695981039346656037ULL;
static void Mix(uint32_t value) {
    for (unsigned j = 0; j < 4; ++j) {
        digest ^= (value >> (j * 8)) & 255;
        digest *= 1099511628211ULL;
    }
}
static void Serial(size_t n, uint32_t bpk) {
    Filter filter(n, bpk); Parent parent(n, bpk);
    Require(filter.SizeInBytes() == parent.SizeInBytes(), "capacity differs from parent");
    Require(filter.SizeInBytes() % 64 == 0, "partial physical line");
    Require(reinterpret_cast<uintptr_t>(filter.Data()) % 64 == 0, "base not line aligned");
    auto keys = Keys(4096, 0x9988776655443322ULL);
    // Cover every probe bit, address-field boundary and repeated insertion.
    for (unsigned bit = 0; bit < 64; ++bit) {
        keys.push_back(uint64_t(1) << bit);
        keys.push_back(~(uint64_t(1) << bit));
    }
    keys.push_back(0); keys.push_back(UINT64_MAX);
    filter.Insert(keys.size(), keys.data()); parent.Insert(keys.size(), keys.data());
    const auto words = Oracle(filter.SizeInBytes(), keys);
    Require(std::memcmp(filter.Data(), words.data(), filter.SizeInBytes()) == 0, "full oracle bitmap differs");
    Require(std::memcmp(filter.Data(), parent.Data(), filter.SizeInBytes()) == 0, "parent bitmap differs");
    filter.Insert(keys.size(), keys.data());
    Require(std::memcmp(filter.Data(), words.data(), filter.SizeInBytes()) == 0, "duplicate insertion changed bitmap");
    for (auto h : keys) Require(filter.ContainsHash(h), "inserted key absent");
    auto queries = Keys(4200, 0x1122334455667788ULL);
    std::copy_n(keys.begin(), 128, queries.begin());
    for (size_t count = 0; count < 132; ++count) {
        for (size_t offset : {0u, 1u, 7u}) {
            std::vector<uint32_t> output(count + 2, 0xfedcba98U);
            Require(filter.Lookup(count, queries.data() + offset, output.data() + 1) == count, "return count");
            Require(output.front() == 0xfedcba98U && output.back() == 0xfedcba98U, "tail guard");
            for (size_t i = 0; i < count; ++i) {
                const auto expected = Answer(words, queries[offset + i]);
                Require(output[i + 1] == expected, "tail answer");
                Require(filter.ContainsHash(queries[offset + i]) == bool(expected), "public singleton");
                Mix(output[i + 1]);
            }
        }
    }
    for (size_t count : {4096u, 4097u, 4127u}) {
        std::vector<uint32_t> output(count + 2, 0xfedcba98U), reference(count);
        filter.Lookup(count, queries.data() + 7, output.data() + 1);
        parent.Lookup(count, queries.data() + 7, reference.data());
        Require(output.front() == 0xfedcba98U && output.back() == 0xfedcba98U, "long guard");
        Require(std::equal(reference.begin(), reference.end(), output.begin() + 1), "parent long outputs");
    }
    for (auto w : words) Mix(w);
}
static void EssentialProbeBits() {
    for (uint64_t h : Keys(32, 0x3141592653589793ULL)) {
        for (unsigned lane = 0; lane < 8; ++lane) {
            Filter filter(1000, 16); filter.Insert(1, &h);
            auto *words = static_cast<uint32_t *>(const_cast<void *>(filter.Data()));
            const size_t base = ((h >> 41) % (filter.SizeInBytes() / 32)) * 8;
            words[base + lane] &= ~(uint32_t(1) << ((h >> (5 * lane)) % 32));
            Require(!filter.ContainsHash(h), "missing required probe bit accepted");
        }
    }
}
static void ParallelChecks() {
    Parallel empty(17, 8);
    empty.InsertParallel(0, nullptr, 0);
    Require(empty.LookupParallel(0, nullptr, nullptr, 0) == 0, "empty parallel batch");
    Require(empty.BuildScratchBytes(0, 0) == 0, "empty parallel scratch");
    auto keys = Keys(32768, 0xaabbccddeeff1234ULL);
    for (size_t i = 0; i < 1024; ++i) keys[i] = keys[i % 7];
    auto queries = Keys(32768, 0xabcdef0123456789ULL);
    std::copy_n(keys.begin(), 16384, queries.begin());
    for (size_t n : {17u, 4096u, 65536u}) {
        const size_t bytes = Filter(n, 8).SizeInBytes();
        const auto words = Oracle(bytes, keys);
        for (size_t workers : {0u, 1u, 2u, 3u, 5u, 8u}) {
            Parallel filter(n, 8);
            const size_t used = filter.BuildWorkers(keys.size(), workers);
            Require((!workers || used <= workers) && used <= bytes / 64, "worker ownership limit");
            Require((used == 1) == (filter.BuildScratchBytes(keys.size(), workers) == 0), "scratch accounting");
            filter.InsertParallel(keys.size(), keys.data(), workers);
            Require(std::memcmp(filter.Data(), words.data(), bytes) == 0, "parallel full bitmap");
            filter.InsertParallel(keys.size(), keys.data(), workers);
            Require(std::memcmp(filter.Data(), words.data(), bytes) == 0, "parallel duplicate bitmap");
            std::vector<uint32_t> output(queries.size() + 2, 0xfedcba98U);
            filter.LookupParallel(queries.size(), queries.data(), output.data() + 1, workers);
            Require(output.front() == 0xfedcba98U && output.back() == 0xfedcba98U, "parallel guards");
            for (size_t i = 0; i < queries.size(); ++i) {
                Require(output[i + 1] == Answer(words, queries[i]), "parallel answer");
                Mix(output[i + 1]);
            }
        }
    }
}
static void Parity() {
    for (size_t n : {17u, 1000u, 4096u}) for (uint32_t bpk : {1u, 8u, 16u}) {
        auto stream = Keys(3072, 0x243f6a8885a308d3ULL);
        Filter filter(n, bpk); filter.Insert(2048, stream.data());
        const auto *words = static_cast<const uint32_t *>(filter.Data());
        std::cout << "{\"n\":" << n << ",\"bpk\":" << bpk << ",\"words\":[";
        for (size_t i = 0; i < filter.SizeInBytes() / 4; ++i)
            std::cout << (i ? "," : "") << words[i];
        std::cout << "],\"output\":[";
        for (size_t i = 0; i < 1152; ++i)
            std::cout << (i ? "," : "") << int(filter.ContainsHash(stream[i < 1024 ? i + 2048 : i - 1024]));
        std::cout << "]}\n";
    }
}
int main(int argc, char **argv) {
    try {
        if (argc == 2 && std::string(argv[1]) == "--parity") { Parity(); return 0; }
        Require(argc == 1, "unknown argument");
        for (size_t n : {0u, 17u, 1000u, 4096u, 65536u})
            for (uint32_t bpk : {1u, 8u, 16u}) Serial(n, bpk);
        EssentialProbeBits(); ParallelChecks();
        bool rejected = false;
        try { Filter invalid(1, 0); } catch (const std::invalid_argument &) { rejected = true; }
        Require(rejected, "zero bpk accepted");
        rejected = false;
        try { Filter invalid(SIZE_MAX, 16); } catch (const std::invalid_argument &) { rejected = true; }
        Require(rejected, "sizing overflow accepted");
        rejected = false;
        try { Filter invalid(size_t(1) << 28, 8); } catch (const std::length_error &) { rejected = true; }
        Require(rejected, "over-cap accepted");
        std::cout << "independent32 serial/parallel/oracle checks passed checksum=" << digest << '\n';
    } catch (const std::exception &e) {
        std::cerr << e.what() << '\n'; return 1;
    }
}
