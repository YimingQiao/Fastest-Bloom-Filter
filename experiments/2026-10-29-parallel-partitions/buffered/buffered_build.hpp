#pragma once
#include "../partitioned_build.hpp"
#include <cstring>
namespace partition_experiment {
// Real contiguous vector storage, aligned to a cache line. Default construction
// begins trivial object lifetimes without value-initializing the staging bytes.
template <class T> struct UninitializedAlignedAllocator : bloom_filters::AlignedAllocator<T, 64> {
    using value_type = T;
    UninitializedAlignedAllocator() = default;
    template <class U> UninitializedAlignedAllocator(const UninitializedAlignedAllocator<U> &) {}
    template <class U> struct rebind { using other = UninitializedAlignedAllocator<U>; };
    template <class U> void construct(U *p) { ::new (static_cast<void *>(p)) U; }
};
struct alignas(64) HashBuffer { uint64_t hashes[8]; };
static_assert(sizeof(HashBuffer) == 64, "one cache line per write-combining buffer");
inline size_t FillStride(size_t parts) { return CheckedMultiply(CheckedAdd(parts, 63) / 64, 64); }
inline size_t RoundHashes(size_t n) { return n == 0 ? 0 : CheckedAdd(n, 7) & ~size_t(7); }
inline size_t BufferedMetadataBytes(size_t workers, size_t parts) {
    const size_t counters = CheckedMultiply(CheckedMultiply(workers, CounterStride(parts)), sizeof(size_t));
    const size_t starts = CheckedMultiply(CheckedAdd(parts, 1), sizeof(size_t));
    const size_t buffers = CheckedMultiply(CheckedMultiply(workers, parts), sizeof(HashBuffer));
    const size_t fills = CheckedMultiply(workers, FillStride(parts));
    return CheckedAdd(CheckedAdd(counters, starts), CheckedAdd(buffers, fills));
}
inline size_t BufferedScratchUpper(size_t n, size_t workers, size_t parts) {
    const size_t nonempty_segments = std::min(n, CheckedMultiply(workers, parts));
    const size_t padded = CheckedAdd(n, CheckedMultiply(nonempty_segments, 7));
    return CheckedAdd(CheckedMultiply(padded, sizeof(uint64_t)), BufferedMetadataBytes(workers, parts));
}
template <class Filter, class Address, size_t TargetBytes>
class BufferedPartitionedBuild {
	Filter filter_;
	Phases phases_;
	size_t actual_scratch_ = 0, padded_hashes_ = 0;
	size_t Lines() const { return filter_.SizeInBytes() / 64; }
public:
	BufferedPartitionedBuild(size_t n, uint32_t bpk) : filter_(n, bpk) {}
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
		return n == 0 || parts == 1 ? 0 : BufferedScratchUpper(n, workers, parts);
	}
	static constexpr size_t PartitionTargetBytes() { return TargetBytes; }
	const Phases &LastPhases() const { return phases_; }
	size_t LastActualScratchBytes() const { return actual_scratch_; }
	size_t LastPaddedHashCount() const { return padded_hashes_; }
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
		actual_scratch_ = 0; padded_hashes_ = n;
		if (n == 0 || parts == 1) {
			filter_.Insert(n, hashes);
			const auto end = Clock::now();
			phases_ = {}; phases_.insert = phases_.total = Nanos(start, end);
			return;
		}
		(void)BufferedScratchUpper(n, workers, parts);
		const size_t stride = CounterStride(parts), fill_stride = FillStride(parts), line_mask = Lines() - 1;
		const unsigned line_shift = bloom_filters::parallel_detail::Log2(Lines());
		auto insert_end = start;
		Phases elapsed;
		{
			std::vector<size_t, bloom_filters::AlignedAllocator<size_t, 64>> counts(CheckedMultiply(workers, stride), 0);
			std::vector<size_t> starts(CheckedAdd(parts, 1));
			std::vector<HashBuffer, UninitializedAlignedAllocator<HashBuffer>> buffers(CheckedMultiply(workers, parts));
			std::vector<uint8_t, bloom_filters::AlignedAllocator<uint8_t, 64>> fills(CheckedMultiply(workers, fill_stride), 0);
			const auto allocated_initial = Clock::now();
			auto shard = [&](uint64_t hash) { return (uint64_t(Address::Line(hash, line_mask)) * parts) >> line_shift; };
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i)
					++counts[worker * stride + shard(hashes[i])];
			});
			const auto counted = Clock::now();
			size_t cursor = 0, unpadded = 0;
			for (size_t part = 0; part < parts; ++part) {
				starts[part] = cursor;
				for (size_t worker = 0; worker < workers; ++worker) {
					auto &count = counts[worker * stride + part];
					const size_t old = count; count = cursor;
					unpadded = CheckedAdd(unpadded, old);
					cursor = CheckedAdd(cursor, RoundHashes(old));
				}
			}
			starts[parts] = cursor; padded_hashes_ = cursor;
			if (unpadded != n) throw std::logic_error("buffered partition count mismatch");
			const auto prefixed = Clock::now();
			// Custom default construction begins u64 lifetimes without an extra
			// zero-fill pass, matching the original uninitialized staging array.
			std::vector<uint64_t, UninitializedAlignedAllocator<uint64_t>> partitioned(cursor);
			actual_scratch_ = CheckedAdd(CheckedMultiply(partitioned.capacity(), 8),
			    CheckedAdd(CheckedMultiply(counts.capacity(), sizeof(size_t)),
			    CheckedAdd(CheckedMultiply(starts.capacity(), sizeof(size_t)),
			    CheckedAdd(CheckedMultiply(buffers.capacity(), sizeof(HashBuffer)), fills.capacity()))));
			const auto allocated_staging = Clock::now();
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i) {
					const uint64_t hash = hashes[i];
					const size_t part = shard(hash);
					auto &fill = fills[worker * fill_stride + part];
					auto &buffer = buffers[worker * parts + part];
					buffer.hashes[fill++] = hash;
					if (fill == 8) {
						auto &position = counts[worker * stride + part];
						std::memcpy(partitioned.data() + position, buffer.hashes, 64);
						position += 8; fill = 0;
					}
				}
				for (size_t part = 0; part < parts; ++part) {
					const size_t fill = fills[worker * fill_stride + part];
					if (fill) {
						auto &buffer = buffers[worker * parts + part];
						// Only a nonempty tail is padded, using a hash already in this
						// exact worker/partition segment. OR insertion is idempotent.
						for (size_t j = fill; j < 8; ++j) buffer.hashes[j] = buffer.hashes[fill - 1];
						auto &position = counts[worker * stride + part];
						std::memcpy(partitioned.data() + position, buffer.hashes, 64);
						position += 8;
					}
				}
			});
			const auto scattered = Clock::now();
			bloom_filters::parallel_detail::For(workers, [&](size_t worker) {
				for (size_t part = worker; part < parts; part += workers) {
					size_t begin = starts[part], remaining = starts[part + 1] - begin;
					while (remaining) {
						// Padding can push an otherwise u32-sized batch past u32.
						// Bounded chunks also leave room for native prefetch/tail arithmetic.
						const uint32_t chunk = static_cast<uint32_t>(std::min(remaining, size_t(1) << 30));
						filter_.Insert(chunk, partitioned.data() + begin);
						begin += chunk; remaining -= chunk;
					}
				}
			});
			insert_end = Clock::now();
			elapsed.allocate = Nanos(start, allocated_initial) + Nanos(prefixed, allocated_staging);
			elapsed.count = Nanos(allocated_initial, counted);
			elapsed.prefix = Nanos(counted, prefixed);
			elapsed.scatter = Nanos(allocated_staging, scattered);
			elapsed.insert = Nanos(scattered, insert_end);
		}
		const auto end = Clock::now();
		elapsed.release = Nanos(insert_end, end); elapsed.total = Nanos(start, end); phases_ = elapsed;
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
