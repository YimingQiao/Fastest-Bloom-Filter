#include "geometry.hpp"
#include <set>
#include <sstream>
#include <vector>
using bloom_filters::FastPatternBF;
template<class BF> void row(const char *name, size_t n, uint32_t bpk) {
    std::cout << name << ',' << n << ',' << bpk << ',';
    try {
        const auto g = exact_budget::Traits<BF>::Plan(n, bpk);
        std::cout << "supported,," << g.allocated_bytes << ',';
        exact_budget::PrintGeometry(std::cout, g);
        std::cout << '\n';
    } catch (const std::exception &e) {
        std::cout << "unsupported," << e.what() << ",,,,,,,,,,,,\n";
    }
}
int main(int argc, char **argv) {
    try {
        if (argc != 3) throw std::invalid_argument("usage: plan REAL_KEY_COUNT BUDGET_BPK");
        auto number = [](const char *s) {
            std::string value = s;
            if (value.empty() || value.find_first_not_of("0123456789") != std::string::npos)
                throw std::invalid_argument("unsigned integers required");
            return std::stoull(value);
        };
        const size_t n = number(argv[1]);
        const uint64_t bpk64 = number(argv[2]);
        if (bpk64 > UINT32_MAX) throw std::invalid_argument("bpk overflow");
        const uint32_t bpk = bpk64;
        (void)exact_budget::Bytes(n, bpk);
        std::cout << "filter,keys,requested_bpk,status,reason,filter_bytes," << exact_budget::GeometryHeader() << '\n';
#define ADD(T, H) row<T>(#T, n, bpk)
        ADD(FastPatternBF, uint64_t);
        BF_REGISTER_EXTERNAL_FILTERS(ADD);
#undef ADD
    } catch (const std::exception &e) { std::cerr << e.what() << '\n'; return 1; }
}
