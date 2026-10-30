#include "masks.hpp"
#include "fast_pattern_BF.h"
#include <array>
#include <cassert>
#include <iostream>
#include <iomanip>
#include <tuple>
#include <unordered_set>
using namespace dictionary_free_experiment;
using bloom_filters::MurmurHash64;
using Filters=std::tuple<Filter<0>,Filter<1>,Filter<2>,Filter<3>,Filter<4>,Filter<5>,Filter<6>,Filter<7>,Filter<8>>;
uint64_t mix(uint64_t seed) {seed+=0x9e3779b97f4a7c15ULL;seed=(seed^(seed>>30))*0xbf58476d1ce4e5b9ULL;seed=(seed^(seed>>27))*0x94d049bb133111ebULL;return seed^(seed>>31);}
template<size_t...I> Filters make_filters(size_t n,unsigned bpk,std::index_sequence<I...>) {return Filters{Filter<I>(n,bpk)...};}
template<unsigned F> void describe() {
    std::unordered_set<uint32_t> unique;
    unsigned least=32,most=0,sum=0,periodic=0;
    for(unsigned code=0;code<1024;++code) {
        uint32_t value=mask<F>(code);unique.insert(value);
        unsigned bits=__builtin_popcount(value);least=std::min(least,bits);most=std::max(most,bits);sum+=bits;
        periodic+=rotate(value,16)==value;
    }
    std::cout<<names[F]<<','<<unique.size()<<','<<least<<','<<most<<','<<sum/1024.0<<','<<periodic<<'\n';
}
int main(int argc,char**argv) {
    if(argc==2&&std::string(argv[1])=="--masks") {
        std::cout<<"family,unique_masks,min_mask_bits,max_mask_bits,mean_mask_bits,period16_codes\n";
        describe<0>();describe<1>();describe<2>();describe<3>();describe<4>();describe<5>();describe<6>();describe<7>();describe<8>();return 0;
    }
    const unsigned kp=argc>1?std::stoul(argv[1]):16,bpk=argc>2?std::stoul(argv[2]):16,qp=argc>4?std::stoul(argv[4]):24;
    const uint64_t seed=argc>3?std::stoull(argv[3]):195023;
    assert((kp==16||kp==20)&&(bpk==16||bpk==32)&&qp>=12&&qp<=24);
    const size_t n=size_t{1}<<kp,q=size_t{1}<<qp;
    const uint64_t base=mix(seed)%((uint64_t{1}<<32)-n-q);
    auto filters=make_filters(n,bpk,std::make_index_sequence<families>{});
    bloom_filters::FastPatternBF native(n,bpk/2);
    std::array<uint64_t,4096> hashes{};
    std::array<uint32_t,4096> answers{};
    for(size_t i=0;i<n;i+=hashes.size()) {
        const size_t len=std::min(hashes.size(),n-i);
        for(size_t j=0;j<len;++j) {
            hashes[j]=MurmurHash64(base+i+j);
            std::apply([&](auto&...filter){(filter.insert(hashes[j]),...);},filters);
        }
        native.Insert(len,hashes.data());
    }
    for(size_t i=0;i<n;i+=hashes.size()) {
        const size_t len=std::min(hashes.size(),n-i);
        for(size_t j=0;j<len;++j)hashes[j]=MurmurHash64(base+i+j);
        native.Lookup(len,hashes.data(),answers.data());
        for(size_t j=0;j<len;++j) {
            assert(answers[j]==1);
            std::apply([&](const auto&...filter){assert((filter.contains(hashes[j])&&...));},filters);
        }
    }
    std::array<uint64_t,families> fp{};uint64_t native_fp=0;
    for(size_t i=0;i<q;i+=hashes.size()) {
        const size_t len=std::min(hashes.size(),q-i);
        for(size_t j=0;j<len;++j)hashes[j]=MurmurHash64(base+n+i+j);
        native.Lookup(len,hashes.data(),answers.data());
        for(size_t j=0;j<len;++j) {
            native_fp+=answers[j];
            assert(answers[j]==std::get<0>(filters).contains(hashes[j]));
        }
        unsigned family=0;
        std::apply([&](const auto&...filter){(( [&]{for(size_t j=0;j<len;++j)fp[family]+=filter.contains(hashes[j]);++family;}() ),...);},filters);
    }
    assert(native_fp==fp[0]);
    assert(native.SizeInBytes()==n*bpk/8);
    std::cout<<"family,keys,queries,actual_bpk,filter_bytes,seed,false_positives,fpr,no_false_negatives\n"<<std::setprecision(17);
    for(unsigned i=0;i<families;++i)std::cout<<names[i]<<','<<n<<','<<q<<','<<bpk<<','<<n*bpk/8<<','<<seed<<','<<fp[i]<<','<<double(fp[i])/q<<",true\n";
}
