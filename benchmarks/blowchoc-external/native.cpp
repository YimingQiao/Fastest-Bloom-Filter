// One C ABI crossing and one virtual dispatch per whole input array. The
// optimizer sees each native public one-key operation inside the typed loop.
#include "snapshot/include/fast_pattern_BF.h"
#include "snapshot/include/four_sector_bloom.h"
#include "snapshot/include/split64_bloom.h"
#include "snapshot/include/byte_split_bloom.h"
#include <algorithm>
#include <memory>
#include <string>

namespace {
thread_local std::string error;
struct Handle {
    virtual ~Handle() = default;
    virtual size_t bytes() const = 0;
    virtual void operation(bool query, unsigned mode, size_t n, const uint64_t *in,
                           uint32_t *out, size_t batch, uint64_t *scratch) = 0;
};
template<class BF> struct Typed final : Handle {
    BF bf;
    Typed(size_t n, uint32_t bpk) : bf(n, bpk) {}
    size_t bytes() const override { return bf.SizeInBytes(); }
    template<bool Query, unsigned Mode>
    void loop(size_t n, const uint64_t *in, uint32_t *out, size_t batch, uint64_t *scratch) {
        for (size_t begin = 0; begin < n;) {
            const size_t length = std::min(batch, n - begin);
            if constexpr (Mode == 2)
                bloom_filters::HashVector(length, in + begin, scratch);
            for (size_t j = 0; j < length; ++j) {
                uint64_t h;
                if constexpr (Mode == 2) h = scratch[j];
                else if constexpr (Mode == 1) h = bloom_filters::MurmurHash64(in[begin + j]);
                else h = in[begin + j];
                if constexpr (Query) bf.Lookup(1, &h, out + begin + j);
                else bf.Insert(1, &h);
            }
            begin += length;
        }
    }
    void operation(bool query, unsigned mode, size_t n, const uint64_t *in,
                   uint32_t *out, size_t batch, uint64_t *scratch) override {
        if (query) {
            if (mode == 0) loop<true, 0>(n, in, out, batch, scratch);
            else if (mode == 1) loop<true, 1>(n, in, out, batch, scratch);
            else loop<true, 2>(n, in, out, batch, scratch);
        } else {
            if (mode == 0) loop<false, 0>(n, in, out, batch, scratch);
            else if (mode == 1) loop<false, 1>(n, in, out, batch, scratch);
            else loop<false, 2>(n, in, out, batch, scratch);
        }
    }
};
template<class Fn> int guarded(Fn fn) noexcept {
    try { fn(); error.clear(); return 0; }
    catch (const std::exception &e) { error = e.what(); }
    catch (...) { error = "unknown C++ exception"; }
    return -1;
}
}
extern "C" {
const char *bc_native_error() noexcept { return error.c_str(); }
int bc_native_create(unsigned kind, size_t n, uint32_t bpk, void **out) noexcept {
    return guarded([&] {
        if (!out) throw std::invalid_argument("null handle output");
        *out = nullptr;
        switch (kind) {
        case 0: *out = new Typed<bloom_filters::FastPatternBF>(n, bpk); break;
        case 1: *out = new Typed<bloom_filters::FourSectorBloomFilter>(n, bpk); break;
        case 2: *out = new Typed<bloom_filters::Split64BloomFilter>(n, bpk); break;
        case 3: *out = new Typed<bloom_filters::ByteSplitBloomFilter>(n, bpk); break;
        default: throw std::invalid_argument("unknown native filter");
        }
    });
}
void bc_native_destroy(void *p) noexcept { delete static_cast<Handle *>(p); }
size_t bc_native_bytes(const void *p) noexcept { return p ? static_cast<const Handle *>(p)->bytes() : 0; }
int bc_native_operation(void *p, unsigned query, unsigned mode, size_t n,
                        const uint64_t *in, uint32_t *out, size_t batch, uint64_t *scratch) noexcept {
    return guarded([&] {
        if (!p || query > 1 || mode > 2 || !batch || batch > UINT32_MAX || (n && !in) ||
            (n && query && !out) || (n && mode == 2 && !scratch))
            throw std::invalid_argument("invalid native whole-array operation");
        static_cast<Handle *>(p)->operation(query, mode, n, in, out, batch, scratch);
    });
}
}
