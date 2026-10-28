#include "buffered_build.hpp"
#include <iostream>
#include <numeric>
#include <vector>
using namespace bloom_filters;
using namespace partition_experiment;
void Require(bool ok, const char *reason) { if (!ok) throw std::runtime_error(reason); }

template <class Filter, class Address, size_t Target>
void CheckVariant(size_t capacity, uint32_t bpk, const std::vector<uint64_t> &keys,
                  const std::vector<uint64_t> &query, const std::vector<uint32_t> &expected) {
	using BF = BufferedPartitionedBuild<Filter, Address, Target>;
	for (size_t requested : {size_t(1), size_t(3), size_t(8)}) {
		BF bf(capacity, bpk);
		const size_t workers = bf.BuildWorkers(keys.size(), requested), parts = bf.BuildPartitions(keys.size(), requested);
		Require(parts >= workers && parts <= bf.SizeInBytes() / 64, "invalid partition count");
		if constexpr (Target) Require((parts & (parts - 1)) == 0, "non-power-of-two cache partition");
		std::vector<size_t> owned(parts);
		size_t previous = 0;
		for (size_t line = 0; line < bf.SizeInBytes() / 64; ++line) {
			const size_t part = bf.PartitionForLine(line, keys.size(), requested);
			Require(part >= previous && part < parts, "non-monotonic or out-of-range ownership");
			++owned[part]; previous = part;
		}
		for (auto count : owned) Require(count > 0, "empty bitmap partition");
		for (auto h : keys) {
			const size_t line = Address::Line(h, bf.SizeInBytes() / 64 - 1);
			Require(bf.PartitionForHash(h, keys.size(), requested) == bf.PartitionForLine(line, keys.size(), requested), "hash/line ownership mismatch");
		}
		const size_t expected_scratch = parts == 1 ? 0 : BufferedScratchUpper(keys.size(), workers, parts);
		Require(bf.BuildScratchBytes(keys.size(), requested) == expected_scratch, "scratch mismatch");
		bf.InsertParallel(keys.size(), keys.data(), requested);
        std::vector<size_t> segment_counts(workers * parts);
        for (size_t worker = 0; worker < workers; ++worker)
            for (size_t i = uint64_t(keys.size()) * worker / workers; i < uint64_t(keys.size()) * (worker + 1) / workers; ++i)
                ++segment_counts[worker * parts + bf.PartitionForHash(keys[i], keys.size(), requested)];
        size_t padded = 0;
        for (auto count : segment_counts) padded += ((count + 7) / 8) * 8;
        if (parts == 1) padded = keys.size();
        Require(bf.LastPaddedHashCount() == padded, "padding count mismatch");
        const size_t exact = parts == 1 ? 0 : padded * 8 + BufferedMetadataBytes(workers, parts);
        Require(bf.LastActualScratchBytes() == exact, "actual allocation mismatch");
        Require(bf.LastActualScratchBytes() <= expected_scratch, "scratch upper bound violated");

		std::vector<uint32_t> out(query.size() + 2, 0xfeed);
		bf.LookupParallel(query.size(), query.data(), out.data() + 1, requested);
		Require(out.front() == 0xfeed && out.back() == 0xfeed, "query output guard");
		Require(std::equal(expected.begin(), expected.end(), out.begin() + 1), "full serial-reference answer mismatch");
		std::vector<uint32_t> inserted(keys.size());
		bf.Lookup(keys.size(), keys.data(), inserted.data());
		for (auto v : inserted) Require(v == 1, "false negative");
		const auto phase = bf.LastPhases();
		const double sum = phase.allocate + phase.count + phase.prefix + phase.scatter + phase.insert + phase.release;
		Require(std::abs(sum - phase.total) < 1, "phase total excludes work");
		bf.InsertParallel(keys.size(), keys.data(), requested);
		bf.Lookup(query.size(), query.data(), out.data() + 1);
		Require(std::equal(expected.begin(), expected.end(), out.begin() + 1), "duplicate insertion changed answers");
		bf.InsertParallel(0, nullptr, requested);
        Require(bf.LastActualScratchBytes() == 0 && bf.LastPaddedHashCount() == 0, "empty build allocated padding");
		Require(bf.LookupParallel(0, nullptr, nullptr, requested) == 0, "empty query");
	}
}
template <class Filter, class Address, unsigned Shift> void CheckFamily() {
	constexpr size_t n = 65539;
	for (size_t capacity : {n, size_t(1) << 20}) for (uint32_t bpk : {8u,16u}) for (bool skew : {false,true}) {
		std::vector<uint64_t> keys(n), query(n * 2 + 3);
		for (size_t i = 0; i < n; ++i) {
			const uint64_t h = MurmurHash64(i + 731);
			keys[i] = skew ? (uint64_t(5) << Shift) | (h & ((uint64_t(1) << Shift) - 1)) : h;
		}
		// Duplicate and extreme low-word masks; all variants must preserve them.
		if (!skew) { keys[0] = 0; keys[1] = ~uint64_t(0); keys[2] = keys[3]; }
		for (size_t i = 0; i < query.size(); ++i) query[i] = MurmurHash64(i + 1000000007);
		for (size_t i = 0; i < n; ++i) query[i] = keys[i];
		std::vector<uint32_t> expected(query.size());
		{ Filter serial(capacity, bpk); serial.Insert(keys.size(), keys.data()); serial.Lookup(query.size(), query.data(), expected.data()); }
		CheckVariant<Filter,Address,0>(capacity,bpk,keys,query,expected);
		CheckVariant<Filter,Address,256u<<10>(capacity,bpk,keys,query,expected);
		CheckVariant<Filter,Address,512u<<10>(capacity,bpk,keys,query,expected);
		CheckVariant<Filter,Address,1024u<<10>(capacity,bpk,keys,query,expected);
	}
}
int main() {
	CheckFamily<FastPatternBF,WordAddress,36>();
	CheckFamily<FourSectorBloomFilter,WordAddress,36>();
	CheckFamily<Split64BloomFilter,SplitAddress,32>();
	for (auto test : {0,1,2,3,4}) {
		bool threw = false;
		try {
			if (test == 0) (void)BufferedScratchUpper(SIZE_MAX,8,16);
			if (test == 1) (void)BufferedScratchUpper(1,SIZE_MAX,16);
			if (test == 2) (void)CounterStride(SIZE_MAX);
			if (test == 3) (void)PowerOfTwoCeil(SIZE_MAX);
            if (test == 4) (void)RoundHashes(SIZE_MAX);
		} catch (const std::length_error &) { threw = true; }
		Require(threw, "scratch overflow was not rejected");
	}
	std::cout << "Uniform/skewed, duplicate, all-inserted/full-output, whole-line ownership, empty and checked-overflow tests passed.\n";
}
