#include "parallel_layout_bloom.h"
#include "parallel_split64_range_bloom.h"
#include "parallel_four_sector_range12_bloom.h"
#include <algorithm>
#include <chrono>
#include <iostream>
#include <numeric>
#include <set>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
using Clock = std::chrono::steady_clock;
static volatile uint64_t sink;
struct RNG {
	uint64_t state;
	uint64_t next() {
		uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
		z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
		z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
		return z ^ (z >> 31);
	}
};
double median(std::vector<double> v) {
	std::sort(v.begin(), v.end());
	return v.size() % 2 ? v[v.size() / 2] : (v[v.size() / 2 - 1] + v[v.size() / 2]) / 2;
}
template <class Filter>
struct SerialLayout : Filter {
	using Filter::Filter;
	void InsertParallel(uint32_t n, const uint64_t *k, size_t) {
		this->Insert(n, k);
	}
	uint32_t LookupParallel(uint32_t n, const uint64_t *k, uint32_t *o, size_t) const {
		return this->Lookup(n, k, o);
	}
};
using Serial = SerialLayout<FastPatternBF>;
using FourSerial = SerialLayout<FourSectorBloomFilter>;
using SplitSerial = SerialLayout<Split64BloomFilter>;
using ByteSerial = SerialLayout<ByteSplitBloomFilter>;
using RangeSerial = SerialLayout<Split64RangeBloomFilter>;
using K12Serial = SerialLayout<FourSectorRange12BloomFilter>;
template <class BF, class = void>
struct HasBuildAccounting : std::false_type {};
template <class BF>
struct HasBuildAccounting<BF, std::void_t<decltype(std::declval<BF>().BuildWorkers(size_t {}, size_t {}))>>
    : std::true_type {};
template <class BF>
struct IsSerial : std::false_type {};
template <class BF>
struct IsSerial<SerialLayout<BF>> : std::true_type {};
template <class BF>
void Run(const char *name, const std::vector<uint64_t> &keys, const std::vector<uint64_t> &query,
         const std::vector<uint8_t> &truth, uint32_t bpk, size_t threads, size_t reps, uint64_t seed, size_t hit) {
	std::vector<uint32_t> out(query.size()), check(4096);
	std::vector<double> build, lookup;
	uint64_t checksum = 0, fp = 0, absent = 0;
	size_t bytes = 0, scratch = 0, bw = 1, qw = 1;
	for (size_t r = 0; r < reps; ++r) {
		BF bf(keys.size(), bpk);
		bytes = bf.SizeInBytes();
		if constexpr (HasBuildAccounting<BF>::value) {
			scratch = bf.BuildScratchBytes(keys.size(), threads);
			bw = bf.BuildWorkers(keys.size(), threads);
		}
		if constexpr (!IsSerial<BF>::value) {
			qw = parallel_detail::Workers(query.size(), threads);
			if constexpr (std::is_same<BF, AtomicFastPatternBF>::value)
				bw = parallel_detail::Workers(keys.size(), threads);
		}
		auto a = Clock::now();
		bf.InsertParallel(keys.size(), keys.data(), threads);
		auto b = Clock::now();
		build.push_back(std::chrono::duration<double, std::nano>(b - a).count() / keys.size());
		for (size_t i = 0; i < keys.size(); i += check.size()) {
			size_t n = std::min(check.size(), keys.size() - i);
			bf.Lookup(n, keys.data() + i, check.data());
			for (size_t j = 0; j < n; ++j)
				if (check[j] != 1)
					throw std::runtime_error("false negative after parallel build");
		}
		bf.LookupParallel(query.size(), query.data(), out.data(), threads);
		a = Clock::now();
		bf.LookupParallel(query.size(), query.data(), out.data(), threads);
		b = Clock::now();
		lookup.push_back(std::chrono::duration<double, std::nano>(b - a).count() / query.size());
		checksum = 14695981039346656037ULL;
		fp = 0;
		absent = 0;
		for (size_t i = 0; i < query.size(); ++i) {
			if (out[i] > 1 || (truth[i] && !out[i]))
				throw std::runtime_error("invalid parallel answer");
			if (!truth[i]) {
				++absent;
				fp += out[i];
			}
			checksum = (checksum ^ out[i]) * 1099511628211ULL;
		}
		sink = checksum;
	}
	std::cout << "cpp," << name << ',' << keys.size() << ',' << query.size() << ',' << bpk << ',' << bytes << ','
	          << threads << ',' << bw << ',' << qw << ',' << scratch << ',' << reps << ',' << seed << ',' << hit << ','
	          << median(build) << ',' << median(lookup) << ',' << absent << ',' << fp << ',';
	if (absent)
		std::cout << double(fp) / absent;
	else
		std::cout << "nan";
	std::cout << ',' << checksum << ',' << *std::min_element(build.begin(), build.end()) << ','
	          << *std::max_element(build.begin(), build.end()) << ',' << *std::min_element(lookup.begin(), lookup.end())
	          << ',' << *std::max_element(lookup.begin(), lookup.end()) << '\n';
}
int main(int argc, char **argv) {
	try {
		auto num = [&](int i, size_t d) {
			if (argc <= i)
				return d;
			std::string s = argv[i];
			if (s.empty() || s.find_first_not_of("0123456789") != std::string::npos)
				throw std::invalid_argument("unsigned integer required");
			return size_t(std::stoull(s));
		};
		size_t kp = num(1, 20), bpk = num(2, 16), qp = num(3, 22), threads = num(4, 4), reps = num(5, 3),
		       seed = num(6, 42), hit = num(7, 0);
		if (kp < 5 || kp > 26 || qp < 12 || qp > 27 || bpk < 1 || bpk > 32 || threads > 1024 || !reps || hit > 100 ||
		    argc > 9)
			throw std::invalid_argument("invalid args");
		size_t n = size_t {1} << kp, q = size_t {1} << qp;
		if (n * bpk >= (size_t {1} << 31))
			throw std::invalid_argument("capacity exceeded");
		const std::string selection = argc > 8 ? argv[8] : "FastPattern";
		const std::set<std::string> defaults {"FastPattern", "FourSector", "Split64", "ByteSplit"};
		const std::set<std::string> available {"FastPattern", "FourSector", "Split64", "ByteSplit",
		                                     "Split64Range", "FourSectorRange12"};
		std::set<std::string> families;
		if (selection == "all") {
			families = defaults;
		} else {
			size_t begin = 0;
			for (;;) {
				const size_t end = selection.find(',', begin);
				const auto family = selection.substr(begin, end == std::string::npos ? end : end - begin);
				if (!available.count(family) || !families.insert(family).second)
					throw std::invalid_argument("unknown, empty or duplicate filter family: " + family);
				if (end == std::string::npos)
					break;
				begin = end + 1;
			}
		}
		if (families.count("Split64Range") || families.count("FourSectorRange12"))
			(void)range_detail::BudgetBytes(n, static_cast<uint32_t>(bpk));
		RNG rng {seed};
		uint64_t base = rng.next() % ((uint64_t {1} << 32) - n - q);
		std::vector<uint64_t> keys(n), query(q);
		std::vector<uint8_t> truth(q);
		for (size_t i = 0; i < n; ++i)
			keys[i] = MurmurHash64(base + i);
		for (size_t i = n; i > 1; --i)
			std::swap(keys[i - 1], keys[rng.next() % i]);
		for (size_t i = 0; i < q; ++i) {
			truth[i] = i % 100 < hit;
			query[i] = MurmurHash64(base + (truth[i] ? rng.next() % n : n + i));
		}
		for (size_t i = q; i > 1; --i) {
			size_t j = rng.next() % i;
			std::swap(query[i - 1], query[j]);
			std::swap(truth[i - 1], truth[j]);
		}
		std::cout << "language,filter,keys,queries,requested_bpk,filter_bytes,threads,build_workers,query_workers,"
		             "build_scratch_bytes,repeats,seed,hit_percent,insert_ns,lookup_ns,absent_queries,false_positives,"
		             "fpr,result_checksum,insert_min_ns,insert_max_ns,lookup_min_ns,lookup_max_ns\n";
		auto selected = [&](const char *family) {
			return families.count(family) != 0;
		};
		std::vector<unsigned> order;
		if (selected("FastPattern"))
			order.insert(order.end(), {0, 1, 2});
		if (selected("FourSector"))
			order.insert(order.end(), {3, 4});
		if (selected("Split64"))
			order.insert(order.end(), {5, 6});
		if (selected("ByteSplit"))
			order.insert(order.end(), {7, 8});
		if (selected("Split64Range"))
			order.insert(order.end(), {9, 10});
		if (selected("FourSectorRange12"))
			order.insert(order.end(), {11, 12});
		if (order.empty())
			throw std::invalid_argument("no matching filter families");
		for (size_t i = order.size(); i > 1; --i)
			std::swap(order[i - 1], order[rng.next() % i]);
		for (auto mode : order) {
			if (mode == 0)
				Run<Serial>("FastPatternSerial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 1)
				Run<ParallelFastPatternBF>("FastPatternPartitioned", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 2)
				Run<AtomicFastPatternBF>("FastPatternAtomic", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 3)
				Run<FourSerial>("FourSectorSerial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 4)
				Run<ParallelFourSectorBloomFilter>("FourSectorPartitioned", keys, query, truth, bpk, threads, reps,
				                                   seed, hit);
			if (mode == 5)
				Run<SplitSerial>("Split64Serial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 6)
				Run<ParallelSplit64BloomFilter>("Split64Partitioned", keys, query, truth, bpk, threads, reps, seed,
				                                hit);
			if (mode == 7)
				Run<ByteSerial>("ByteSplitSerial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 8)
				Run<ParallelByteSplitBloomFilter>("ByteSplitPartitioned", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 9)
				Run<RangeSerial>("Split64RangeSerial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 10)
				Run<ParallelSplit64RangeBloomFilter>("Split64RangePartitioned", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 11)
				Run<K12Serial>("FourSectorRange12Serial", keys, query, truth, bpk, threads, reps, seed, hit);
			if (mode == 12)
				Run<ParallelFourSectorRange12BloomFilter>("FourSectorRange12Partitioned", keys, query, truth, bpk, threads, reps, seed, hit);
		}
	} catch (const std::exception &e) {
		std::cerr << e.what() << '\n';
		return 1;
	}
}
