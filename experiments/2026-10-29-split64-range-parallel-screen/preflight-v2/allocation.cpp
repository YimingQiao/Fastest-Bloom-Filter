// Allocation-only public capacity observation: no inserts, queries or clocks.
#include "../geometry.hpp"
#include <sstream>
using bloom_filters::FastPatternBF;
struct Mute {
    std::ostringstream ignored;
    std::streambuf *saved = std::cout.rdbuf(ignored.rdbuf());
    ~Mute() { std::cout.rdbuf(saved); }
};
template<class BF> void emit(const char *name, size_t n, uint32_t bpk) {
    const auto geometry = exact_budget::Traits<BF>::Plan(n,bpk);
    size_t observed;
    {
        Mute mute;
        BF filter = exact_budget::Traits<BF>::Make(n,bpk);
        observed = filter.SizeInBytes();
        if (observed != geometry.allocated_bytes || observed > geometry.budget_bytes)
            throw std::runtime_error("public actual backing differs from planned capacity");
    } // Destruction precedes next bitmap. SizeInBytes is not malloc usable-size/RSS.
    std::cout << name << ',' << n << ',' << bpk << ",supported,," << observed << ',';
    exact_budget::PrintGeometry(std::cout,geometry);
    std::cout << '\n';
}
int main(int argc, char **argv) {
    try {
        if(argc != 3) throw std::invalid_argument("allocation_actual REAL_N BUDGET_BPK");
        auto number=[](const char *text) {
            const std::string s=text;
            if(s.empty() || s.find_first_not_of("0123456789")!=std::string::npos)
                throw std::invalid_argument("unsigned integer required");
            return std::stoull(s);
        };
        const auto n=number(argv[1]), bpk=number(argv[2]);
        if(bpk>UINT32_MAX) throw std::invalid_argument("bpk overflow");
        (void)exact_budget::Bytes(n,bpk);
        std::cout << "filter,keys,requested_bpk,status,reason,filter_bytes," << exact_budget::GeometryHeader() << '\n';
#define ADD(T,H) emit<T>(#T,n,bpk)
        ADD(FastPatternBF,uint64_t);
        BF_REGISTER_EXTERNAL_FILTERS(ADD);
#undef ADD
    } catch(const std::exception &error) { std::cerr << error.what() << '\n'; return 1; }
}
