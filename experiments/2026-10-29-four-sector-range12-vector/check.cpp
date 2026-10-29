#include "../2026-10-29-four-sector-range-probe-pilot/filter.hpp"
#include "four_sector_range12.h"
#include "../2026-10-29-four-sector-range24/four_sector_range24.h"
#include <array>
#include <cstring>
#include <iostream>
#include <memory>
#include <stdexcept>
using bloom_filters::RangeBytes;
static void need(bool ok,const char* why){if(!ok)throw std::runtime_error(why);}
static uint64_t mix(uint64_t x){x^=x>>32;x*=0xd6e8feb86659fd93ULL;x^=x>>32;x*=0xd6e8feb86659fd93ULL;return x^(x>>32);}
// Historical three-bit dictionary expressed as bit positions, independent of
// the candidate's packed-mask shifts. The original dictionary remains pinned.
static constexpr unsigned triples[16][3]={
 {0,1,3},{0,4,9},{0,6,13},{0,8,18},{0,1,12},{0,2,15},{0,4,16},{0,3,8},
 {0,6,15},{0,7,18},{0,1,10},{0,2,5},{0,4,10},{0,7,15},{0,1,13},{0,3,14}};
static std::array<size_t,12> bits(uint64_t h,size_t bytes,unsigned k){
 std::array<size_t,12> result{};size_t at=0;
 const size_t line=static_cast<unsigned __int128>(h>>40)*(bytes/64)/16777216;
 const unsigned base=(h>>32)&3;const uint32_t low=h;
 for(unsigned sector=0;sector<4;++sector){
  const unsigned within=base^(sector?((h>>(32+2*sector))&3):0);
  const size_t word=line*16+sector*4+within;
  const unsigned r=sector*8;
  const uint32_t code=(low>>r)|(low<<((32-r)%32));
  const unsigned index=code%16,rotation=(code/16)%32;
  const bool three=k==12||(k==10&&sector>=2)||(k==9&&sector==3);
  for(unsigned j=0;j<(three?3u:2u);++j){
   const unsigned bit=three?triples[index][j]:(j?index+1:0);
   result[at++]=word*32+(bit+rotation)%32;
  }
 }
 need(at==k,"oracle probe count");return result;
}
template<unsigned K> static void check(size_t requested){
 static_assert(K==12);
 bloom_filters::FourSectorRange12 filter(RangeBytes{requested});
 const size_t bytes=requested/64*64;
 need(filter.SizeInBytes()==bytes,"actual allocation rounding");
 std::vector<uint32_t> oracle(bytes/4);
 std::vector<uint64_t> keys;
 for(uint64_t i=0;i<16384;++i)keys.push_back(mix(i+0x517cc1b727220a95ULL));
 // Every cyclic 9-bit sector code; shared hash-bit correlations remain present.
 for(unsigned sector=0;sector<4;++sector)for(uint32_t code=0;code<512;++code){
  const unsigned r=sector*8;const uint32_t lo=(code<<r)|(code>>((32-r)%32));
  keys.push_back((uint64_t(0x000000e4)<<32)|lo);
 }
 for(size_t i=0;i<2048;++i)keys.push_back(keys[i%31]);
 for(uint64_t h:keys){const auto probes=bits(h,bytes,K);for(unsigned j=0;j<K;++j)oracle[probes[j]/32]|=uint32_t{1}<<(probes[j]%32);}
 const auto input=keys;
 need(filter.Lookup(0,nullptr,nullptr)==0,"null empty lookup");
 filter.Insert(0,nullptr);filter.Insert(997,keys.data());filter.Insert(keys.size()-997,keys.data()+997);
 need(keys==input,"insert changed input");
 need(std::memcmp(filter.Data(),oracle.data(),bytes)==0,"complete scalar bitmap oracle");
 range_probe_pilot::Filter<12> scalar(RangeBytes{requested});scalar.Insert(keys.size(),keys.data());
 need(std::memcmp(filter.Data(),scalar.Data(),bytes)==0,"calibrated scalar K12 bitmap replay");
 if constexpr(K==8){
  bloom_filters::FourSectorRange24 old(RangeBytes{requested});old.Insert(keys.size(),keys.data());
  need(old.SizeInBytes()==bytes&&std::memcmp(old.Data(),filter.Data(),bytes)==0,"old K8 full bitmap replay");
 }
 std::vector<uint32_t> present(keys.size());filter.Lookup(keys.size(),keys.data(),present.data());
 need(std::all_of(present.begin(),present.end(),[](uint32_t x){return x==1;}),"false negative");
 std::vector<uint64_t> queries(32773);
 for(size_t i=0;i<queries.size();++i)queries[i]=i%2?mix(i+0xd1b54a32d192ed03ULL):keys[i%keys.size()];
 const auto input_queries=queries;
 std::vector<size_t> counts;for(size_t n=0;n<=131;++n)counts.push_back(n);
 for(size_t n:{4095,4096,4097,32768,32769})counts.push_back(n);
 for(size_t offset=0;offset<4;++offset)for(size_t n:counts){
  std::vector<uint32_t> out(n+2,0xf00d1234);
  need(filter.Lookup(n,queries.data()+offset,out.data()+1)==n,"wrong output count");
  need(out.front()==0xf00d1234&&out.back()==0xf00d1234,"output guard");
  for(size_t i=0;i<n;++i){const auto probes=bits(queries[i+offset],bytes,K);bool expected=true;
   for(unsigned j=0;j<K;++j)expected&=(oracle[probes[j]/32]>>(probes[j]%32))&1;
   need(out[i+1]==expected,"complete dense output oracle");
  }
 }
 need(queries==input_queries,"query changed input");
 std::cout<<"{\"k\":"<<K<<",\"requested_bytes\":"<<requested<<",\"bytes\":"<<bytes<<",\"inserted\":"<<keys.size()<<",\"tail_cases\":"<<counts.size()*4<<"}\n";
}
int main()try{
 for(size_t bytes:{128UL,129UL,192UL,320UL,262208UL,2097216UL,100663296UL}){
  check<12>(bytes);
 }
 for(size_t bytes:{0UL,127UL,(1UL<<28)+1}){
  bool rejected=false;try{bloom_filters::FourSectorRange12 f(RangeBytes{bytes});}catch(const std::length_error&){rejected=true;}
  need(rejected,"invalid budget accepted");
 }
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 2;}
