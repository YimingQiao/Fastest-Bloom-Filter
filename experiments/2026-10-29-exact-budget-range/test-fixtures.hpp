#pragma once
// Contract-only fixtures. They are never registered in a performance binary.
template<unsigned FailCall, bool Guard = false>
class ExactFixture {
    static inline unsigned constructions = 0;
    size_t n_, inserted_ = 0, bytes_;
    mutable unsigned calls_ = 0;
public:
    ExactFixture(size_t n, uint32_t bpk) : n_(n), bytes_(exact_budget::Bytes(n, bpk)) {
        if (++constructions != 1) throw std::runtime_error("query-only constructed more than one filter");
    }
    size_t SizeInBytes() const { return bytes_; }
    void Insert(uint32_t n, const uint64_t *) { inserted_ += n; }
    uint32_t Lookup(uint32_t n, const uint64_t *, uint32_t *out) const {
        if (inserted_ != n_) throw std::runtime_error("query used an incomplete filter");
        std::fill(out, out + n, 1);
        if (++calls_ == FailCall) {
            if constexpr (Guard) out[n] = 0;
            else if (n) out[n - 1] = 0;
        }
        return n;
    }
};
using QueryOnceFixture = ExactFixture<0>;
using LatePureFault = ExactFixture<5>;
using LateHashFault = ExactFixture<6>;
using LateGuardFault = ExactFixture<5, true>;
namespace exact_budget {
template<unsigned F, bool G> struct Traits<ExactFixture<F, G>> : ExternalMake<ExactFixture<F, G>> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const auto b = Bytes(n, bpk);
        return {b,b,b,1,b,1,"test_fixture"};
    }
};
}
