#pragma once
// This exact file is to be compiled in BOTH workers. It has no Boost includes.
// Adapter-owned scratch is allocated before entering these functions.
#include <cstddef>
#include <cstdint>
#include <algorithm>

namespace vldb_stage2 {
enum class QueryMode : unsigned { PublicSingle=0, DenseBatch1=1, DenseBatch4096=2 };
// All six permutations: each mode occupies each position twice and every
// ordered within-trial neighbor occurs twice. Multiples of six are mandatory.
inline unsigned Phase(unsigned seed,unsigned trial,unsigned slot) {
  static constexpr unsigned orders[6][3]={{0,1,2},{0,2,1},{1,0,2},{1,2,0},{2,0,1},{2,1,0}};
  return orders[(trial+seed%6)%6][slot];
}
template<class Filter>
__attribute__((noinline)) void DenseCall(const Filter& filter,uint32_t n,const uint32_t* keys,uint32_t* out) {
  filter.Dense(n,keys,out);
}
template<class Filter>
__attribute__((noinline)) void Query(const Filter& filter, QueryMode mode,
                                    size_t n,const uint32_t* keys,uint32_t* out) {
  if(mode==QueryMode::PublicSingle) {
    // Independent-query throughput. The compiler may inline and interleave
    // public one-key calls; this is not a dependent-load latency measurement.
    for(size_t i=0;i<n;++i) out[i]=filter.Single(keys[i])?1u:0u;
    return;
  }
  const uint32_t batch=mode==QueryMode::DenseBatch1?1:4096;
  for(size_t i=0;i<n;i+=batch) {
    const uint32_t count=static_cast<uint32_t>(std::min<size_t>(batch,n-i));
    DenseCall(filter,count,keys+i,out+i);
  }
}
} // namespace vldb_stage2
