#include "multiply_code_split64.h"
#include "cyclic_split64.h"
#include "split64_reference.h"
#include <array>
#include <iostream>
using namespace bloom_filters;
// Identical bijective common64 hash and counter domains to the frozen cyclic pilot.
static uint64_t hash64(uint64_t x) {
    x ^= x >> 32; x *= 0xd6e8feb86659fd93ULL;
    x ^= x >> 32; x *= 0xd6e8feb86659fd93ULL;
    return x ^ (x >> 32);
}
template<class Filter> static void run(const char *name,size_t n,size_t bpk) {
    constexpr size_t queries=1UL<<24,seed=42,batch=4096;
    const size_t bytes=n*bpk/8;
    Filter filter(RangeBytes{bytes});
    std::array<uint64_t,batch> hashes{};
    std::array<uint32_t,batch+2> out{};
    const uint64_t salt=seed*0x9e3779b97f4a7c15ULL;
    for(size_t at=0;at<n;at+=batch) {
        const size_t take=std::min(batch,n-at);
        for(size_t j=0;j<take;++j)hashes[j]=hash64((at+j)^salt);
        filter.Insert(take,hashes.data());
    }
    for(size_t at=0;at<n;at+=batch) {
        const size_t take=std::min(batch,n-at);
        for(size_t j=0;j<take;++j)hashes[j]=hash64((at+j)^salt);
        out.fill(0xfeed);
        if(filter.Lookup(take,hashes.data(),out.data()+1)!=take)throw std::runtime_error("wrong positive count");
        if(out[0]!=0xfeed || out[take+1]!=0xfeed)throw std::runtime_error("positive output guard");
        for(size_t j=0;j<take;++j)if(out[j+1]!=1)throw std::runtime_error("false negative");
    }
    size_t fp=0;uint64_t checksum=0;
    for(size_t at=0;at<queries;at+=batch) {
        for(size_t j=0;j<batch;++j)hashes[j]=hash64((n+queries+at+j)^salt);
        out.fill(0xfeed);
        if(filter.Lookup(batch,hashes.data(),out.data()+1)!=batch)throw std::runtime_error("wrong negative count");
        if(out.front()!=0xfeed || out.back()!=0xfeed)throw std::runtime_error("negative output guard");
        for(size_t j=0;j<batch;++j) {
            const uint32_t value=out[j+1];
            if(value>1)throw std::runtime_error("nondense output");
            fp+=value;checksum=checksum*31+value;
        }
    }
    if(filter.SizeInBytes()!=bytes)throw std::runtime_error("wrong actual backing allocation");
    std::cout<<name<<','<<n<<','<<bpk<<','<<filter.SizeInBytes()<<','<<seed<<','<<queries<<','<<fp<<','<<checksum<<std::endl;
}
int main() {
    std::cout<<"filter,keys,actual_bpk,filter_bytes,seed,calibration_negatives,false_positives,checksum\n";
    for(unsigned power:{16U,25U})for(size_t bpk:{16UL,24UL,28UL,32UL}) {
        run<Split64Range>("Split64Range",1UL<<power,bpk);
        run<CyclicSplit64Range>("CyclicSplit64Range",1UL<<power,bpk);
        run<MultiplyCodeSplit64Range>("MultiplyCodeSplit64Range",1UL<<power,bpk);
    }
}
