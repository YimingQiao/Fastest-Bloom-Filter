#include "baseline_snapshot.h"
#include "wide_pattern.h"
#include <chrono>
#include <algorithm>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
using namespace bloom_filters;
volatile uint64_t sink;
template <class F>
__attribute__((noinline)) void query(const F &f, const uint64_t *p, uint32_t *out, size_t n, size_t batch) {
	for (size_t i = 0; i < n; i += batch)
		f.Lookup(std::min(batch, n - i), p + i, out + i);
}
double median(std::vector<double> v) {
	std::sort(v.begin(), v.end());
	return v[v.size() / 2];
}
int main(int argc, char **argv) {
	if (argc != 6)
		return 2;
	size_t n = 1ull << std::stoul(argv[1]), q = 1ull << 20;
	unsigned bpk = std::stoul(argv[2]), hit = std::stoul(argv[3]);
	size_t batch = std::stoul(argv[4]);
	unsigned seed = std::stoul(argv[5]);
	std::mt19937_64 rng(seed);
	std::vector<uint64_t, AlignedAllocator<uint64_t, 4096>> keys(n), hashes(q);
	std::vector<uint32_t, AlignedAllocator<uint32_t, 4096>> output(q + 16);
	auto *out = output.data() + 16;
	std::vector<bool> present(q);
	for (size_t i = 0; i < n; ++i)
		keys[i] = MurmurHash64(i + seed * 100000000ull);
	for (size_t i = 0; i < q; ++i)
		hashes[i] = i % 100 < hit ? keys[rng() % n] : MurmurHash64(n + i + seed * 100000000ull);
	std::shuffle(keys.begin(), keys.end(), rng);
	std::shuffle(hashes.begin(), hashes.end(), rng);
	FastPatternBF original(n, bpk);
	wide_pattern::Filter<DICT_BITS, USE_GATHER> candidate(n, bpk);
	original.Insert(n, keys.data());
	candidate.Insert(n, keys.data());
	query(candidate, hashes.data(), out, q, batch);
	for (size_t i = 0; i < q; ++i)
		if (out[i] != candidate.Contains(hashes[i]))
			throw std::runtime_error("SIMD/scalar mismatch");
	uint64_t positive = std::accumulate(out, out + q, uint64_t {0});
	for (size_t i = 0; i < n; i += 4096) {
		size_t size = std::min<size_t>(4096, n - i);
		candidate.Lookup(size, keys.data() + i, out);
		for (size_t j = 0; j < size; ++j)
			if (out[j] != 1)
				throw std::runtime_error("false negative");
	}
	std::vector<double> a, b;
	for (int rep = 0; rep < 9; ++rep) {
		auto run = [&](auto &bf, std::vector<double> &times) {
			query(bf, hashes.data(), out, q, batch);
			auto begin = std::chrono::steady_clock::now();
			query(bf, hashes.data(), out, q, batch);
			auto end = std::chrono::steady_clock::now();
			times.push_back(std::chrono::duration<double, std::nano>(end - begin).count() / q);
			sink = std::accumulate(out, out + q, uint64_t {0});
		};
		if (rng() & 1) {
			run(original, a);
			run(candidate, b);
		} else {
			run(candidate, b);
			run(original, a);
		}
	}
	std::cout << (1 << DICT_BITS) << ',' << USE_GATHER << ',' << n << ',' << bpk << ',' << hit << ',' << batch << ','
	          << seed << ',' << median(a) << ',' << median(b) << ',' << median(a) / median(b) << ',' << positive
	          << '\n';
}
