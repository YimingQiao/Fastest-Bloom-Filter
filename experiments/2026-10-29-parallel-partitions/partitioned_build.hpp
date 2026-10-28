#pragma once
#include "parallel_layout_bloom.h"
#include <chrono>
#include <limits>
#include <stdexcept>

namespace partition_experiment {
using Clock = std::chrono::steady_clock;
struct Phases {
	double allocate = 0, count = 0, prefix = 0, scatter = 0, insert = 0, release = 0, total = 0;
};
inline double Nanos(Clock::time_point a, Clock::time_point b) {
	return std::chrono::duration<double, std::nano>(b - a).count();
}
inline size_t CheckedAdd(size_t a, size_t b) {
	if (b > SIZE_MAX - a) throw std::length_error("partition metadata addition overflow");
	return a + b;
}
inline size_t CheckedMultiply(size_t a, size_t b) {
	if (a && b > SIZE_MAX / a) throw std::length_error("partition scratch multiplication overflow");
	return a * b;
}
inline size_t CounterStride(size_t partitions) {
	constexpr size_t per_line = 64 / sizeof(size_t);
	return CheckedMultiply(CheckedAdd(partitions, per_line - 1) / per_line, per_line);
}
inline size_t ScratchBytes(size_t n, size_t workers, size_t partitions) {
	const size_t counters = CheckedMultiply(workers, CounterStride(partitions));
	const size_t metadata = CheckedAdd(counters, CheckedAdd(partitions, 1));
	return CheckedAdd(CheckedMultiply(n, sizeof(uint64_t)), CheckedMultiply(metadata, sizeof(size_t)));
}
inline size_t PowerOfTwoCeil(size_t value) {
	size_t result = 1;
	while (result < value) result = CheckedMultiply(result, 2);
	return result;
}

// These public layout traits are algebraically identical to the frozen native
// mapping. FastPattern's two sectors and FourSector's four sectors only change
// the low four word-index bits; all updates stay in this one 64-byte line.
struct WordAddress {
	static size_t Line(uint64_t hash, size_t line_mask) { return (hash >> 36) & line_mask; }
};
struct SplitAddress {
	static size_t Line(uint64_t hash, size_t line_mask) { return (hash >> 32) & line_mask; }
};

// TargetBytes=0 is the instrumented P=W control. Positive targets decouple
// partitions from worker count while keeping every partition a whole-line range.
template <class Filter, class Address, size_t TargetBytes>
class CachePartitionedBuild {
	Filter filter_;
	Phases phases_;
	size_t Lines() const { return filter_.SizeInBytes() / 64; }
public:
	CachePartitionedBuild(size_t n, uint32_t bpk) : filter_(n, bpk) {}
	size_t SizeInBytes() const { return filter_.SizeInBytes(); }
	void Insert(uint32_t n, const uint64_t *hashes) { filter_.Insert(n, hashes); }
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const { return filter_.Lookup(n, hashes, out); }
	size_t BuildWorkers(size_t n, size_t requested) const {
		return bloom_filters::parallel_detail::Workers(n, requested, Lines());
	}
	size_t BuildPartitions(size_t n, size_t requested) const {
		const size_t workers = BuildWorkers(n, requested);
		if constexpr (TargetBytes == 0) return workers;
		else {
			static_assert(TargetBytes >= 64 && (TargetBytes & (TargetBytes - 1)) == 0, "power-of-two cache-line target");
			const size_t needed = CheckedAdd(SizeInBytes(), TargetBytes - 1) / TargetBytes;
			return std::min(Lines(), PowerOfTwoCeil(std::max(workers, needed)));
		}
	}
	size_t BuildScratchBytes(size_t n, size_t requested) const {
		const size_t workers = BuildWorkers(n, requested), parts = BuildPartitions(n, requested);
		return parts == 1 ? 0 : ScratchBytes(n, workers, parts);
	}
	static constexpr size_t PartitionTargetBytes() { return TargetBytes; }
	const Phases &LastPhases() const { return phases_; }
	// Test hook: the partition ID is a deterministic function of one whole line.
	size_t PartitionForLine(size_t line, size_t n, size_t requested) const {
		if (line >= Lines()) throw std::out_of_range("line out of range");
		return (uint64_t(line) * BuildPartitions(n, requested)) >> bloom_filters::parallel_detail::Log2(Lines());
	}
	size_t PartitionForHash(uint64_t hash, size_t n, size_t requested) const {
		return PartitionForLine(Address::Line(hash, Lines() - 1), n, requested);
	}
	void InsertParallel(uint32_t n, const uint64_t *hashes, size_t requested = 0) {
		const auto start = Clock::now();
		const size_t workers = BuildWorkers(n, requested), parts = BuildPartitions(n, requested);
		if (parts == 1) {
			filter_.Insert(n, hashes);
			const auto end = Clock::now();
			phases_ = {};
			phases_.insert = phases_.total = Nanos(start, end);
			return;
		}
		(void)ScratchBytes(n, workers, parts); // Reject all metadata/input overflow before allocating.
		const size_t stride = CounterStride(parts), line_mask = Lines() - 1;
		const unsigned line_shift = bloom_filters::parallel_detail::Log2(Lines());
		auto insert_end = start;
		Phases elapsed;
		{
			std::vector<size_t, bloom_filters::AlignedAllocator<size_t, 64>> counts(CheckedMultiply(workers, stride), 0);
			std::vector<size_t> starts(CheckedAdd(parts, 1));
			std::unique_ptr<uint64_t[]> partitioned(new uint64_t[n]);
			const auto allocated = Clock::now();
			// Keep multiply/reduce identical to the original W-partition algorithm;
			// P being a power of two is not used for a separate addressing shortcut.
			auto shard = [&](uint64_t hash) { return (uint64_t(Address::Line(hash, line_mask)) * parts) >> line_shift; };
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i)
					++counts[worker * stride + shard(hashes[i])];
			});
			const auto counted = Clock::now();
			size_t cursor = 0;
			for (size_t part = 0; part < parts; ++part) {
				starts[part] = cursor;
				for (size_t worker = 0; worker < workers; ++worker) {
					auto &count = counts[worker * stride + part];
					const size_t old = count;
					count = cursor;
					cursor += old; // Sum of disjoint input counts, bounded by uint32_t n.
				}
			}
			starts[parts] = cursor;
			if (cursor != n) throw std::logic_error("partition count mismatch");
			const auto prefixed = Clock::now();
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i) {
					auto &position = counts[worker * stride + shard(hashes[i])];
					partitioned[position++] = hashes[i];
				}
			});
			const auto scattered = Clock::now();
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				// Exactly one worker visits each partition. Every bitmap line belongs
				// to exactly one partition; native non-atomic writes cannot overlap.
				for (size_t part = worker; part < parts; part += workers)
					filter_.Insert(static_cast<uint32_t>(starts[part + 1] - starts[part]), partitioned.get() + starts[part]);
			});
			insert_end = Clock::now();
			elapsed.allocate = Nanos(start, allocated);
			elapsed.count = Nanos(allocated, counted);
			elapsed.prefix = Nanos(counted, prefixed);
			elapsed.scatter = Nanos(prefixed, scattered);
			elapsed.insert = Nanos(scattered, insert_end);
		} // All scratch destruction/deallocation remains inside the outer timer.
		const auto end = Clock::now();
		elapsed.release = Nanos(insert_end, end);
		elapsed.total = Nanos(start, end);
		phases_ = elapsed;
	}
	uint32_t LookupParallel(uint32_t n, const uint64_t *hashes, uint32_t *out, size_t requested = 0) const {
		const size_t workers = bloom_filters::parallel_detail::Workers(n, requested);
		bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
			const size_t begin = uint64_t(n) * worker / workers, end = uint64_t(n) * (worker + 1) / workers;
			if (begin < end) filter_.Lookup(end - begin, hashes + begin, out + begin);
		});
		return n;
	}
};
} // namespace partition_experiment
