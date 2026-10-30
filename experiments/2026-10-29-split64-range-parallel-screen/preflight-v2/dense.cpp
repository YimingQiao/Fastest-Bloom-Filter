// Untimed complete public-output fixture; built once per current/reference API.
#ifdef BF_DENSE_REFERENCE
#include "../../2026-10-29-exact-budget-range/geometry.hpp"
#else
#include "../geometry.hpp"
#endif
#include "retained.hpp"
#include <sstream>
#include <vector>
using bloom_filters::FastPatternBF;
template<class T,class=void> struct IsRaw : std::false_type {};
template<class T> struct IsRaw<T,std::void_t<decltype(T::kRawKeyApi)>> : std::bool_constant<T::kRawKeyApi> {};
static void require(bool yes,const char *message) {if(!yes)throw std::runtime_error(message);}
struct Mute {
    std::ostringstream ignored;
    std::streambuf *saved=std::cout.rdbuf(ignored.rdbuf());
    ~Mute(){std::cout.rdbuf(saved);}
};
static uint64_t input(uint64_t value,bool raw) {return raw?value:bloom_filters::MurmurHash64(value);}
static void WriteDenseArray(const std::vector<uint32_t>& values) {
    std::cout << '[';
    for(size_t i=0;i<values.size();++i){if(i)std::cout<<',';std::cout<<values[i];}
    std::cout << ']';
}
template<class BF> void fixture(const char *name) {
    for(size_t n:{64UL,1024UL,65536UL}) for(uint32_t cap:{16u,24u,32u}) {
        constexpr size_t q=4097,cal=4096;
        std::vector<uint64_t> inserted(n),query(q),negative(cal);
        for(size_t i=0;i<n;++i) inserted[i]=input(731+i,IsRaw<BF>::value);
        for(size_t i=0;i<q;++i) query[i]=input(731+n+i,IsRaw<BF>::value);
        for(size_t i=0;i<q;i+=4) query[i]=inserted[i%n];
        for(size_t i=0;i<cal;++i) negative[i]=input(731+n+q+i,IsRaw<BF>::value);
        std::vector<uint32_t> outputs(q),calibration(cal),positive(n);
        size_t bytes;
        {
            Mute mute;
            const auto geometry=exact_budget::Traits<BF>::Plan(n,cap);
            BF filter=exact_budget::Traits<BF>::Make(n,cap);
            bytes=filter.SizeInBytes();
            require(bytes==geometry.allocated_bytes && bytes<=geometry.budget_bytes,"actual fixture backing mismatch");
            filter.Insert(n,inserted.data());
            filter.Lookup(n,inserted.data(),positive.data());
            for(auto answer:positive) require(answer==1,"full inserted fixture false negative");
            filter.Lookup(q,query.data(),outputs.data());
            filter.Lookup(cal,negative.data(),calibration.data());
            for(auto answer:outputs)require(answer<=1,"invalid dense query answer");
            for(auto answer:calibration)require(answer<=1,"invalid dense calibration answer");
        }
        std::cout<<"{\"filter\":\""<<name<<"\",\"keys\":"<<n<<",\"budget_bpk\":"<<cap
                 <<",\"filter_bytes\":"<<bytes<<",\"inserted_checked\":"<<n<<",\"outputs\":";
        WriteDenseArray(outputs);std::cout<<",\"calibration_outputs\":";WriteDenseArray(calibration);std::cout<<"}\n";
    }
}
int main() {
    try {
#define ADD(T,H) fixture<T>(#T)
        BF_RETAINED(ADD);
#ifndef BF_DENSE_REFERENCE
        ADD(Split64RangeNative,uint64_t);
#endif
#undef ADD
    }catch(const std::exception& error){std::cerr<<error.what()<<'\n';return 1;}
}
