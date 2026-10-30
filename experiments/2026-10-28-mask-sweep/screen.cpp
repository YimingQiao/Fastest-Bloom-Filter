#ifdef ENTROPY_SCREEN
#include "entropy_filter.h"
#else
#include "fast_pattern_snapshot.h"
#endif
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>
struct SplitMix64 {
    uint64_t state;
    uint64_t next() {
        uint64_t z=(state+=0x9e3779b97f4a7c15ULL);
        z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;
        z=(z^(z>>27))*0x94d049bb133111ebULL;
        return z^(z>>31);
    }
};
int main(int argc,char**argv) {
    using namespace bloom_filters;
    const uint32_t bpk=argc>1?std::stoul(argv[1]):16;
    const uint64_t seed=argc>2?std::stoull(argv[2]):42;
    const unsigned power=argc>3?std::stoul(argv[3]):20;
    const unsigned query_power=argc>4?std::stoul(argv[4]):24;
    if((bpk!=8&&bpk!=16)||power>25||query_power>28) return 1;
    const uint64_t n=1ull<<power,q=1ull<<query_power;
    SplitMix64 rng{seed};
    const uint64_t base=rng.next()%((1ull<<32)-n-q);
    std::vector<uint64_t> hashes(n);
    for(uint64_t i=0;i<n;++i) hashes[i]=MurmurHash64(base+i);
    for(uint64_t i=n;i>1;--i) std::swap(hashes[i-1],hashes[rng.next()%i]);
    FastPatternBF bf(n,bpk);
    bf.Insert(n,hashes.data());
    constexpr uint32_t batch=4096;
    std::vector<uint32_t> output(batch+2,0xdeadbeef);
    for(uint64_t i=0;i<n;i+=batch) {
        const uint32_t len=std::min<uint64_t>(batch,n-i);
        bf.Lookup(len,hashes.data()+i,output.data()+1);
        for(uint32_t j=0;j<len;++j) if(output[j+1]!=1) return 2;
    }
    std::vector<uint64_t> query(batch);
    uint64_t positives=0;
    for(uint64_t i=0;i<q;i+=batch) {
        const uint32_t len=std::min<uint64_t>(batch,q-i);
        for(uint32_t j=0;j<len;++j) query[j]=MurmurHash64(base+n+i+j);
        bf.Lookup(len,query.data(),output.data()+1);
        for(uint32_t j=0;j<len;++j) {
            if(output[j+1]>1) return 3;
            positives+=output[j+1];
        }
    }
    if(output.front()!=0xdeadbeef||output.back()!=0xdeadbeef) return 4;
    const double p=double(positives)/q,z=1.959963984540054;
    const double upper=(p+z*z/(2*q)+z*std::sqrt(p*(1-p)/q+z*z/(4*double(q)*q)))/(1+z*z/q);
    std::cout<<std::setprecision(12)<<MASK_BITS<<','<<bpk<<','<<n<<','<<q<<','<<seed<<','<<base<<','
        <<bf.SizeInBytes()<<','<<8.0*bf.SizeInBytes()/n<<','<<positives<<','<<p<<','<<upper<<",0\n";
}
