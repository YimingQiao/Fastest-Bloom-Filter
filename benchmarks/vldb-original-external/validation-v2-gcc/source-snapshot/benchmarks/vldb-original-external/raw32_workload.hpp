#pragma once
#include <algorithm>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
namespace vldb_external {
inline uint32_t Permute32(uint32_t x, uint32_t seed) {
  x += seed; x ^= x >> 16; x *= UINT32_C(0x7feb352d);
  x ^= x >> 15; x *= UINT32_C(0x846ca68b); x ^= x >> 16; return x;
}
struct SplitMix {
  uint64_t state;
  uint64_t Next() { uint64_t x=(state+=UINT64_C(0x9e3779b97f4a7c15));
    x=(x^(x>>30))*UINT64_C(0xbf58476d1ce4e5b9);
    x=(x^(x>>27))*UINT64_C(0x94d049bb133111eb); return x^(x>>31); }
};
template<class T> void Shuffle(std::vector<T>& v, SplitMix& rng) {
  for(size_t n=v.size(); n>1; --n) std::swap(v[n-1],v[rng.Next()%n]);
}
struct Raw32Workload {
  std::vector<uint32_t> inserted, query, calibration;
  std::vector<uint8_t> present;
  uint64_t absent_count=0, present_count=0;
  Raw32Workload(uint64_t n,uint64_t q,uint64_t calibration_count,unsigned hit,uint32_t seed) {
    if(!n || hit>100 || n>UINT32_MAX || q>UINT32_MAX || calibration_count>UINT32_MAX)
      throw std::invalid_argument("raw32 workload bounds");
    present_count=(q/100)*hit+std::min<uint64_t>(q%100,hit); absent_count=q-present_count;
    if(absent_count>(UINT64_C(1)<<32)-n || calibration_count>(UINT64_C(1)<<32)-n-absent_count)
      throw std::overflow_error("raw32 counter domains overlap or overflow");
    SplitMix rng{seed}; inserted.resize(n); query.resize(q); calibration.resize(calibration_count);
    for(uint64_t i=0;i<n;++i) inserted[i]=Permute32(static_cast<uint32_t>(i),seed);
    Shuffle(inserted,rng);
    struct Item { uint32_t key; uint8_t present; }; std::vector<Item> mixed(q);
    uint64_t negative=n;
    for(uint64_t i=0;i<q;++i) {
      const bool found=i%100<hit;
      mixed[i]={found?inserted[rng.Next()%n]:Permute32(static_cast<uint32_t>(negative++),seed),static_cast<uint8_t>(found)};
    }
    Shuffle(mixed,rng); present.resize(q);
    for(uint64_t i=0;i<q;++i) { query[i]=mixed[i].key; present[i]=mixed[i].present; }
    for(uint64_t i=0;i<calibration_count;++i) calibration[i]=Permute32(static_cast<uint32_t>(n+absent_count+i),seed);
  }
};
} // namespace vldb_external
