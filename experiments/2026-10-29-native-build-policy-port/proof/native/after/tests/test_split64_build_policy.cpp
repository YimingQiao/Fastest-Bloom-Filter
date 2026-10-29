#include "parallel_layout_bloom.h"
#include "parallel_split64_range_bloom.h"
#include <iostream>

using namespace bloom_filters;
static void Need(bool ok, const char *message) {
    if (!ok) throw std::runtime_error(message);
}
static uint64_t Next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
static void Metadata() {
    for (size_t n : {0UL, 1UL, 16383UL, 16384UL, 65535UL, 65536UL, 65537UL, SIZE_MAX})
        for (size_t bytes : {128UL, 262143UL, 262144UL, 262145UL, 262208UL, 524288UL})
            for (size_t requested : {0UL, 1UL, 4UL, 8UL}) {
                const size_t expected = n <= 65536 && bytes <= 262144 ? 1 : requested;
                Need(parallel_detail::Split64BuildRequest(n, bytes, requested) == expected,
                     "exact request boundary");
            }
    ParallelFourSectorBloomFilter four(131072, 8);
    ParallelByteSplitBloomFilter byte(131072, 8);
    Need(four.SizeInBytes() == 262144 && byte.SizeInBytes() == 262144, "control bytes");
    Need(four.BuildWorkers(65536, 8) == 8 && byte.BuildWorkers(65536, 8) == 8,
         "unrelated layout worker policy changed");
}
template<class Make>
static void Check(Make make, size_t bytes, size_t n, size_t requested, bool hotspot) {
    uint64_t state = 0x243f6a8885a308d3ULL;
    std::vector<uint64_t> old(hotspot ? 4096 : 0), hashes(n), queries(32771);
    for (auto &h : old) h = Next(state);
    for (auto &h : hashes) { h = Next(state); if (hotspot) h &= 0xffffffffULL; }
    for (auto &h : queries) h = Next(state);
    for (size_t i = 0; i < queries.size(); i += 3) queries[i] = hashes[i % hashes.size()];
    auto serial = make();
    auto parallel = make();
    Need(serial.SizeInBytes() == bytes && parallel.SizeInBytes() == bytes, "actual bytes");
    const size_t effective = n <= 65536 && bytes <= 262144 ? 1 : requested;
    const size_t expected_workers = parallel_detail::Workers(n, effective, bytes / 64);
    Need(parallel.BuildWorkers(n, requested) == expected_workers, "worker metadata");
    Need((parallel.BuildScratchBytes(n, requested) == 0) == (expected_workers == 1),
         "scratch metadata");
    serial.Insert(old.size(), old.data());
    parallel.Insert(old.size(), old.data());
    serial.Insert(hashes.size(), hashes.data());
    parallel.InsertParallel(hashes.size(), hashes.data(), requested);
    parallel.InsertParallel(hashes.size(), hashes.data(), requested); // Idempotent incremental call.
    for (const auto *input : {&old, &hashes}) {
        std::vector<uint32_t> present(input->size());
        parallel.Lookup(input->size(), input->data(), present.data());
        Need(std::all_of(present.begin(), present.end(), [](uint32_t v) { return v == 1; }),
             "old or new insertion missing");
    }
    std::vector<uint32_t> expected(queries.size()), out(queries.size() + 2, 0xfeed);
    serial.Lookup(queries.size(), queries.data(), expected.data());
    parallel.LookupParallel(queries.size(), queries.data(), out.data() + 1, requested);
    Need(out.front() == 0xfeed && out.back() == 0xfeed, "query guard");
    Need(std::equal(expected.begin(), expected.end(), out.begin() + 1), "full mixed output");
    parallel.InsertParallel(0, nullptr, requested);
    parallel.LookupParallel(0, nullptr, nullptr, requested);
}
int main() {
    Metadata();
    for (bool range : {false, true}) {
        struct Fixture { size_t bytes, n, requested; bool hotspot; };
        const Fixture fixtures[] = {
            {262144, 65536, 1, false}, {262144, 65537, 8, false},
            {262144, 65536, 4, true}, {range ? 262208UL : 524288UL, 65536, 8, false},
            {range ? 262208UL : 524288UL, 65536, 0, true}, {262144, 65536, 8, true}};
        for (const auto &c : fixtures) {
            if (range)
                Check([&] { return ParallelSplit64RangeBloomFilter(RangeBytes{c.bytes}); },
                      c.bytes, c.n, c.requested, c.hotspot);
            else
                Check([&] { return ParallelSplit64BloomFilter(c.bytes / 2, 8); },
                      c.bytes, c.n, c.requested, c.hotspot);
        }
    }
    std::cout << "Split64 bounded native build policy: boundaries and 12 incremental cases passed\n";
}
