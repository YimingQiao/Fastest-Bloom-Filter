#include "parallel_bloom.h"
#include <atomic>
#include <stdexcept>
#include <thread>
#include <vector>
using namespace bloom_filters;
void Require(bool ok) {
	if (!ok)
		throw std::runtime_error("parallel correctness failure");
}
int main() {
	for (uint32_t bpk : {4u, 16u})
		for (size_t threads : {1u, 2u, 3u, 7u, 8u}) {
			constexpr uint32_t n = 65539;
			std::vector<uint64_t> keys(n), query(n * 2);
			for (size_t i = 0; i < query.size(); ++i)
				query[i] = MurmurHash64(i);
			std::copy(query.begin(), query.begin() + n, keys.begin());
			FastPatternBF serial(n, bpk);
			ParallelFastPatternBF parallel(n, bpk);
			AtomicFastPatternBF atomic(n, bpk);
			serial.Insert(n, keys.data());
			parallel.InsertParallel(n, keys.data(), threads);
			atomic.InsertParallel(n, keys.data(), threads);
			std::vector<uint32_t> expected(query.size()), got(query.size());
			serial.Lookup(query.size(), query.data(), expected.data());
			parallel.LookupParallel(query.size(), query.data(), got.data(), threads);
			Require(got == expected);
			atomic.LookupParallel(query.size(), query.data(), got.data(), threads);
			Require(got == expected);
		}
	AtomicFastPatternBF concurrent(65536, 16);
	std::vector<uint64_t> keys(65536);
	for (size_t i = 0; i < keys.size(); ++i)
		keys[i] = (uint64_t {7} << 32) | (MurmurHash64(i) & 0xffffffffu);
	ParallelFastPatternBF hot(keys.size(), 16);
	hot.InsertParallel(keys.size(), keys.data(), 7);
	std::vector<uint32_t> hot_out(keys.size());
	hot.LookupParallel(keys.size(), keys.data(), hot_out.data(), 7);
	for (auto x : hot_out)
		Require(x == 1);
	concurrent.Insert(1024, keys.data());
	std::atomic<bool> done {false}, started {false};
	std::thread reader([&] {
		std::vector<uint32_t> out(1024);
		started.store(true, std::memory_order_release);
		while (!done.load(std::memory_order_acquire)) {
			concurrent.Lookup(1024, keys.data(), out.data());
			for (auto x : out)
				Require(x == 1);
		}
	});
	while (!started.load(std::memory_order_acquire))
		std::this_thread::yield();
	concurrent.InsertParallel(keys.size(), keys.data(), 8);
	done.store(true, std::memory_order_release);
	reader.join();
	std::vector<uint32_t> out(keys.size());
	concurrent.Lookup(keys.size(), keys.data(), out.data());
	for (auto x : out)
		Require(x == 1);
	ParallelFastPatternBF empty(0, 16);
	empty.InsertParallel(0, nullptr, 8);
	empty.LookupParallel(0, nullptr, nullptr, 8);
	concurrent.InsertParallel(0, nullptr, 8);
	concurrent.LookupParallel(0, nullptr, nullptr, 8);
}
