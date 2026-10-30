#pragma once
#include "masks.hpp"
#include "../../benchmarks/cpp-external/adapters.hpp"
#include <limits>
#include <stdexcept>
namespace dictionary_free_experiment {
template<unsigned Family>class Adapter {
    Filter<Family> filter_;
    static unsigned actual_bits(size_t n,unsigned requested) {
        if(!n||(n&(n-1))||!requested||n>std::numeric_limits<size_t>::max()/requested)
            throw std::invalid_argument("experiment requires power-of-two n and valid requested size");
        const size_t bits=std::max<size_t>(512,n*requested);
        if(bits>=(size_t{1}<<31))throw std::length_error("maximum 256MiB");
        size_t words=32;while(words<=bits/32)words*=2;
        return static_cast<unsigned>(words*32/n);
    }
public:
    Adapter(size_t n,unsigned requested):filter_(n,actual_bits(n,requested)){}
    size_t SizeInBytes()const{return filter_.bytes();}
    void Insert(uint32_t n,const uint64_t*h){for(size_t i=0;i<n;++i)filter_.insert(h[i]);}
    uint32_t Lookup(uint32_t n,const uint64_t*h,uint32_t*out)const{for(size_t i=0;i<n;++i)out[i]=filter_.contains(h[i]);return n;}
};
}
using DenseTableScalar=dictionary_free_experiment::Adapter<0>;
using AdjacentPairsScalar=dictionary_free_experiment::Adapter<4>;
using AsymmetricPairsScalar=dictionary_free_experiment::Adapter<5>;
using NonperiodicPair8Scalar=dictionary_free_experiment::Adapter<6>;
using NonperiodicPair4Scalar=dictionary_free_experiment::Adapter<7>;
using TriadOddSingletonScalar=dictionary_free_experiment::Adapter<8>;
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
ADD(DenseTableScalar,uint64_t); \
ADD(AdjacentPairsScalar,uint64_t); \
ADD(AsymmetricPairsScalar,uint64_t); \
ADD(NonperiodicPair8Scalar,uint64_t); \
ADD(NonperiodicPair4Scalar,uint64_t); \
ADD(TriadOddSingletonScalar,uint64_t); \
ADD(FastFilterFixed16,uint64_t)
