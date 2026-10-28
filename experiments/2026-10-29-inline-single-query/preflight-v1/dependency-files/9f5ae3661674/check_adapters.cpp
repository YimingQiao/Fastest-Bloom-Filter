#include "fast_pattern_BF.h"
#include "adapters.hpp"
#include "executor.hpp"
#include <iostream>
#include <type_traits>
#include <vector>
using namespace external_parallel;
template<class T,class=void> struct Raw : std::false_type {};
template<class T> struct Raw<T,std::void_t<decltype(T::kRawKeyApi)>> : std::integral_constant<bool,T::kRawKeyApi> {};
void Require(bool value,const char *message) {if(!value)throw std::runtime_error(message);}
template<class BF> void Check() {
    constexpr size_t n=4099,q=16387;
    std::vector<uint64_t> keys(n),query(q);
    for(size_t i=0;i<n;++i) keys[i]=Raw<BF>::value ? i+731 : bloom_filters::MurmurHash64(i+731);
    // Separate initialization and positive replacement avoids a Clang 23
    // conditional-modulo/gather fixture miscompile seen in previous experiments.
    for(size_t i=0;i<q;++i) query[i]=Raw<BF>::value ? i+n+731 : bloom_filters::MurmurHash64(i+n+731);
    for(size_t i=1;i<q;i+=2) query[i]=keys[i%n];
    BF building(n,8); building.Insert(n,keys.data());
    const BF &bf=building;
    std::vector<uint32_t> inserted(n),expected(q);
    bf.Lookup(n,keys.data(),inserted.data());
    for(auto v:inserted) Require(v==1,"false negative after serial build");
    bf.Lookup(q,query.data(),expected.data());
    for(size_t batch:{size_t(1),size_t(7),size_t(31),size_t(4096)}) {
        const size_t count=BatchCount(q,batch);
        for(size_t workers:{size_t(1),size_t(3),size_t(8)}) {
            if(workers>count)continue;
            std::vector<uint32_t> result(q+2,0xfeed);
            Execute(workers,[&](size_t worker) {
                const auto range=BatchRange(count,workers,worker);
                for(size_t b=range.begin;b<range.end;++b) {
                    const size_t i=b*batch,len=std::min(batch,q-i);
                    bf.Lookup(len,query.data()+i,result.data()+i+1);
                }
            });
            Require(result.front()==0xfeed && result.back()==0xfeed,"output guard");
            Require(std::equal(expected.begin(),expected.end(),result.begin()+1),"concurrent full output mismatch");
        }
    }
}
int main() {
    Check<bloom_filters::FastPatternBF>();Check<FourSectorBloomFilter>();Check<Split64BloomFilter>();Check<ByteSplitBloomFilter>();
    Check<FastFilterFixed16>();Check<FastFilterFixed16SingleV1>();Check<FastFilterFixed32Bulk>();Check<FastFilterSimdBlock>();Check<FastFilterSimdBlockSingleV1>();
    Check<Boost192Multi64K8>();Check<Boost192ClassicK11>();
    Check<RocksDBFastLocalBloom64>();Check<RocksDBFastLocalBloom64K8Batch32>();Check<PageBloom6Default>();
    std::cout<<"Fourteen native/external immutable adapter types match full serial outputs at T=1/3/8 and batch=1/7/31/4096.\n";
}
