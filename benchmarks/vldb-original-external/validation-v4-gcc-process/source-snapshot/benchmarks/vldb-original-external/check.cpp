#include "test_types.hpp"
#include "raw32_workload.hpp"
#include "guarded_buffer.hpp"
#include <set>
using namespace vldb_external;
static void Require(bool value,const char* message) { if(!value) throw std::runtime_error(message); }
static uint32_t Inverse(uint32_t x,uint32_t seed) {
  x^=x>>16;x*=UINT32_C(0x43021123);x^=(x>>15)^(x>>30);
  x*=UINT32_C(0x1d69e2a5);x^=x>>16;return x-seed;
}
static uint64_t digest=14695981039346656037ULL;
static void Consume(uint32_t value) { digest=(digest^value)*1099511628211ULL; }

template<class Filter> uint64_t CheckQuery(const Filter& filter,const uint32_t* source,size_t n) {
  Require(PositionScratchBytes(n)==n*sizeof(uint32_t),"scratch contract");
  GuardedBuffer<uint32_t> input(n),positions(n),out(n);
  if(n) std::copy(source,source+n,input.data());
  input.ReadOnly();positions.Fill(UINT32_C(0xcccccccc));out.Fill(UINT32_C(0xeeeeeeee));
  // Validate the compact public result before dense conversion in this proof.
  const auto count=filter.Compact(n,input.data(),positions.data());
  positions.CheckPrefix();input.CheckPrefix();ValidatePositions(n,positions.data(),count);
  PositionsToDense(n,positions.data(),count,out.data());out.CheckPrefix();
  size_t expected=0;
  for(size_t i=0;i<n;++i) {
    const auto value=uint32_t(filter.Contains(input.data()[i]));
    Require(out.data()[i]==value,"compact/dense/singleton mismatch");expected+=value;
    Consume(value);
  }
  Require(count==expected,"wrong compact hit count");
  // Exercise the actual combined adapter too; conversion stays inside any future
  // query timer. Bounds/duplicate/guard checks remain outside that API.
  positions.Fill(UINT32_C(0xcccccccc));out.Fill(UINT32_C(0xeeeeeeee));
  const auto dense_count=filter.Dense(n,input.data(),out.data(),positions.data());
  positions.CheckPrefix();out.CheckPrefix();input.CheckPrefix();
  ValidatePositions(n,positions.data(),dense_count);Require(dense_count==count,"dense hit count changed");
  for(size_t i=0;i<n;++i) Require(out.data()[i]==uint32_t(filter.Contains(input.data()[i])),"combined dense mismatch");
  return count;
}

template<class Triplet> void CheckTriplet(const Raw32Workload& w,size_t bits) {
  using D=typename Triplet::Dynamic;using S=typename Triplet::Static;using P=typename Triplet::Public;
  P::Configure();
  D dynamic(bits);S statik(bits);P artifact(bits);artifact.CheckConfiguration();
  bool rejected=false;try { P::Configure(); } catch(const std::logic_error&) { rejected=true; }
  Require(rejected,"live public instance silently retuned");
  dynamic.Insert(0,nullptr);statik.Insert(0,nullptr);artifact.Insert(0,nullptr);
  Require(dynamic.Dense(0,nullptr,nullptr,nullptr)==0 && statik.Dense(0,nullptr,nullptr,nullptr)==0 && artifact.Dense(0,nullptr,nullptr,nullptr)==0,"zero API");
  // Empty bitmap forces all-miss stores, including the AVX2 full-width stores.
  for(size_t n:{0UL,1UL,3UL,4UL,7UL,8UL,15UL,16UL,31UL,32UL,63UL,64UL,65UL,127UL,128UL,129UL,4096UL}) {
    Require(CheckQuery(dynamic,w.query.data(),n)==0,"empty dynamic match");
    Require(CheckQuery(statik,w.query.data(),n)==0,"empty static match");
    Require(CheckQuery(artifact,w.query.data(),n)==0,"empty artifact match");
  }
  dynamic.Insert(w.inserted.size(),w.inserted.data());statik.Insert(w.inserted.size(),w.inserted.data());artifact.Insert(w.inserted.size(),w.inserted.data());
  std::vector<uint32_t> duplicates(257,w.inserted.front());
  dynamic.Insert(duplicates.size(),duplicates.data());statik.Insert(duplicates.size(),duplicates.data());artifact.Insert(duplicates.size(),duplicates.data());
  Require(dynamic.logical_bytes()==statik.logical_bytes() && dynamic.logical_bytes()==artifact.logical_bytes(),"length mismatch");
  Require(!std::memcmp(dynamic.data(),statik.data(),dynamic.logical_bytes()),"static bitmap mismatch");
  Require(!std::memcmp(dynamic.data(),artifact.data(),dynamic.logical_bytes()),"artifact bitmap mismatch");
  for(auto key:w.inserted) Require(dynamic.Contains(key)&&statik.Contains(key)&&artifact.Contains(key),"false negative");
  for(size_t off=0;off<8;++off) for(size_t n=0;n<=131;++n) {
    const auto a=CheckQuery(dynamic,w.query.data()+off,n),b=CheckQuery(statik,w.query.data()+off,n),c=CheckQuery(artifact,w.query.data()+off,n);
    Require(a==b && a==c,"public API hit-count mismatch");
  }
  std::vector<uint32_t> all_hits(4127);
  for(size_t i=0;i<all_hits.size();++i) all_hits[i]=w.inserted[i%w.inserted.size()];
  for(size_t n:{15UL,16UL,31UL,32UL,63UL,64UL,65UL,127UL,128UL,129UL,4096UL,4097UL,4127UL}) {
    Require(CheckQuery(dynamic,all_hits.data(),n)==n,"all-hit dynamic mismatch");
    Require(CheckQuery(statik,all_hits.data(),n)==n,"all-hit static mismatch");
    Require(CheckQuery(artifact,all_hits.data(),n)==n,"all-hit artifact mismatch");
  }
}

template<class Triplet,class DifferentTriplet> void CheckCase(const Raw32Workload& w) {
  CheckTriplet<Triplet>(w,32768);
  bool rejected=false;
  try { DifferentTriplet::Public::Configure(); } catch(const std::logic_error&) { rejected=true; }
  Require(rejected,"different U accepted after destruction despite non-overwriting upstream tuner");
}

template<class Native> void CheckNative(const Raw32Workload& w) {
  NativeRaw<Native> filter(w.inserted.size(),8);
  std::vector<uint64_t> scratch(std::max(w.inserted.size(),w.query.size()));
  std::vector<uint32_t> out(w.query.size());
  filter.Insert(w.inserted.size(),w.inserted.data(),scratch.data());
  for(auto key:w.inserted) Require(filter.Contains(key),"native false negative");
  filter.Dense(w.query.size(),w.query.data(),out.data(),scratch.data());
  for(size_t i=0;i<w.query.size();++i) Require(out[i]==uint32_t(filter.Contains(w.query[i])),"native public scalar/batch mismatch");
}

int main(int argc,char** argv) {
  if(argc!=2) { std::cerr<<"Usage: vldb_public_check sector32-u1|sector64-u1|register64-u0|sector32-u2|sector32-u4|sector64-u2|sector64-u4|native\n";return 2; }
  const std::string which=argv[1];
  const std::set<std::string> allowed={"sector32-u1","sector64-u1","register64-u0","sector32-u2","sector32-u4","sector64-u2","sector64-u4","native"};
  if(!allowed.count(which)) return 2;
  for(uint32_t seed:{0u,42u,UINT32_MAX}) for(uint32_t i=0;i<65536;++i) Require(Inverse(Permute32(i,seed),seed)==i,"permutation inverse");
  Raw32Workload w(1024,4096,4096,50,42);
  std::set<uint32_t> all(w.inserted.begin(),w.inserted.end());Require(all.size()==w.inserted.size(),"duplicate insertion keys");
  for(size_t i=0;i<w.query.size();++i) Require((all.count(w.query[i])!=0)==bool(w.present[i]),"query domain overlap");
  for(size_t i=0;i<w.query.size();++i) if(!w.present[i]) Require(all.insert(w.query[i]).second,"negative aliases insert/query");
  for(auto key:w.calibration) Require(all.insert(key).second,"calibration overlaps earlier domains");
  bool rejected=false;try { Raw32Workload invalid(UINT32_MAX,2,1,0,42); } catch(const std::overflow_error&) { rejected=true; }
  Require(rejected,"domain overflow accepted");
  rejected=false;try { PositionScratchBytes(uint64_t(UINT32_MAX)+1); } catch(const std::overflow_error&) { rejected=true; }
  Require(rejected,"scratch overflow accepted");
  const uint32_t duplicate_positions[]={1,1},bad_position[]={2};
  for(unsigned which=0;which<3;++which) {
    rejected=false;try { ValidatePositions(2,which==0?duplicate_positions:bad_position,which==0?2:which==1?1:3); } catch(const std::runtime_error&) { rejected=true; }
    Require(rejected,"invalid compact metadata accepted");
  }
  if(which=="sector32-u1") CheckCase<Sector32<1>,Sector32<2>>(w);
  else if(which=="sector64-u1") CheckCase<Sector64<1>,Sector64<2>>(w);
  else if(which=="register64-u0") CheckCase<Register64,Sector64<1>>(w);
  else if(which=="sector32-u2") CheckCase<Sector32<2>,Sector32<1>>(w);
  else if(which=="sector32-u4") CheckCase<Sector32<4>,Sector32<1>>(w);
  else if(which=="sector64-u2") CheckCase<Sector64<2>,Sector64<1>>(w);
  else if(which=="sector64-u4") CheckCase<Sector64<4>,Sector64<1>>(w);
  else {
    CheckNative<bloom_filters::FastPatternBF>(w);CheckNative<bloom_filters::ByteSplitBloomFilter>(w);
    CheckNative<bloom_filters::FourSectorBloomFilter>(w);CheckNative<bloom_filters::Split64BloomFilter>(w);
  }
  std::cout<<"Public API/guarded exact-n scratch checks passed "<<which<<" "<<digest<<"; no timings or FPR leadership claims\n";
}
