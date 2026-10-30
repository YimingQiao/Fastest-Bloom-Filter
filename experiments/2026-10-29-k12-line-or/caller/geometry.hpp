#pragma once
#include "../control.hpp"
#include "../candidate.hpp"
#include <iostream>

// Only the two exact-capacity native types in this experiment are registered.
// The shared caller's Geometry layout/output contract is retained.
namespace exact_budget {
struct Geometry {
    size_t budget_bytes, allocated_bytes, logical_bytes, unit_bytes, units;
    int probes;
    const char *kind;
    const char *probe_policy = "fixed";
    size_t constructor_argument = 0;
    unsigned page_level = 0;
    uint32_t native_bpk = 0;
    const char *origin = "project_experiment";
};
inline size_t Bytes(size_t n, uint32_t bpk) {
    return bloom_filters::range_detail::BudgetBytes(n, bpk);
}
template<class BF> struct Traits {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk);
        const size_t allocation = bloom_filters::range_detail::LineCount(budget) * 64;
        Geometry g{budget, allocation, allocation, 64, allocation / 64, 12, "project_four_range24_mapping"};
        g.constructor_argument = budget;
        return g;
    }
    static BF Make(size_t n, uint32_t bpk) {
        return BF(bloom_filters::RangeBytes{Plan(n, bpk).budget_bytes});
    }
};
inline const char *GeometryHeader() {
    return "budget_bytes,logical_bytes,geometry_kind,unit_bytes,unit_count,effective_probes,probe_policy,constructor_argument,page_level,native_constructor_bpk,implementation_origin";
}
inline void PrintGeometry(std::ostream &out, const Geometry &g) {
    out << g.budget_bytes << ',' << g.logical_bytes << ',' << g.kind << ',' << g.unit_bytes << ',' << g.units
        << ',' << g.probes << ',' << g.probe_policy << ',' << g.constructor_argument << ',' << g.page_level << ',' << g.native_bpk << ',' << g.origin;
}
} // namespace exact_budget
