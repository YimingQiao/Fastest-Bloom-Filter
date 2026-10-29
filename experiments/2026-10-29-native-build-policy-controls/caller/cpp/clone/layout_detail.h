#pragma once
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>

namespace native_clone {
namespace layout_detail {
// Preserve the repository's strict-next-power-of-two allocation contract.
// The cap also leaves the upper six hash bits independent of word addressing.
inline size_t WordCount(size_t keys, uint32_t bits_per_key) {
	if (!bits_per_key || keys > std::numeric_limits<size_t>::max() / bits_per_key)
		throw std::invalid_argument("invalid Bloom filter size");
	const size_t bits = std::max<size_t>(512, keys * bits_per_key);
	if (bits >= (size_t {1} << 31))
		throw std::length_error("cache-line layouts support at most 256 MiB");
	size_t words = 32;
	while (words <= bits / 32)
		words *= 2;
	return words;
}
} // namespace layout_detail
template <class Filter>
class ParallelLayoutBloomFilter;
} // namespace native_clone
