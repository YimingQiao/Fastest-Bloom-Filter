#include "nearby_geometry.hpp"
#include "../../benchmarks/vldb-original-external/adapters.hpp"
#include "../../benchmarks/vldb-original-external/guarded_buffer.hpp"
#include "../../benchmarks/vldb-original-external/raw32_workload.hpp"
#include <array>
#include <iostream>
#include <string>
#include <vector>

namespace old = vldb_external;
namespace stage = vldb_stage2;
static void Need(bool value, const char* message) {
  if (!value) throw std::runtime_error(message);
}
static void CheckPlanner(const stage::Geometry& g, bool nearby) {
  if(nearby) vldb_nearby::Check(g);
  if(g.address==dtl::block_addressing::MAGIC) {
    const auto next=dtl::next_cheap_magic(g.block_count+1).divisor;
    Need(nearby || stage::Round64(size_t(next)*g.block_bytes)>g.budget_bytes/64*64,"MAGIC planner left a larger fitting divisor");
    dtl::block_addressing_logic<dtl::block_addressing::MAGIC> address(g.block_count);
    for(uint32_t i=0;i<65536;++i) {
      const uint32_t h=old::Permute32(i,UINT32_MAX);
      Need(address.get_block_idx(h)==h%g.block_count,"MAGIC modulo oracle mismatch");
    }
    for(uint32_t h:{0u,1u,UINT32_MAX})
      Need(address.get_block_idx(h)==h%g.block_count,"MAGIC boundary mismatch");
  } else {
    dtl::block_addressing_logic<dtl::block_addressing::POWER_OF_TWO> address(g.block_count);
    for(uint32_t i=0;i<65536;++i) {
      const uint32_t h=old::Permute32(i,UINT32_MAX);
      Need(address.get_block_idx(h)==uint32_t(uint64_t(h)*g.block_count>>32),"pow2 address oracle mismatch");
    }
  }
}
template<class Word, unsigned W, unsigned S, unsigned K, unsigned U,
         dtl::block_addressing Address> struct Types {
  using Dynamic = old::DirectDynamic<Word, W, S, K, U>;
  using Static = old::StaticLogic<Word, W, S, K, U, Address>;
  using Facade = std::conditional_t<sizeof(Word) == 4, dtl::bbf_32, dtl::bbf_64>;
  using Public = old::ArtifactPublic<Facade, W, S, K, U>;
};
template<class Filter> uint64_t Query(const Filter& f, const uint32_t* keys, size_t n) {
  old::GuardedBuffer<uint32_t> input(n), compact(n), dense(n);
  if (n) std::copy(keys, keys+n, input.data());
  input.ReadOnly(); compact.Fill(0xcccccccc); dense.Fill(0xeeeeeeee);
  const uint64_t count = f.Compact(n, input.data(), compact.data());
  old::ValidatePositions(n, compact.data(), count);
  old::PositionsToDense(n, compact.data(), count, dense.data());
  input.CheckPrefix(); compact.CheckPrefix(); dense.CheckPrefix();
  uint64_t checksum = UINT64_C(14695981039346656037), found = 0;
  for (size_t i=0; i<n; ++i) {
    const uint32_t expected = f.Contains(input.data()[i]);
    Need(dense.data()[i] == expected, "compact/dense/singleton mismatch");
    checksum = (checksum ^ expected) * UINT64_C(1099511628211);
    found += expected;
  }
  Need(found == count, "compact count mismatch");
  dense.Fill(0xeeeeeeee); compact.Fill(0xcccccccc);
  Need(f.Dense(n,input.data(),dense.data(),compact.data()) == count, "Dense count mismatch");
  old::ValidatePositions(n, compact.data(), count);
  for (size_t i=0;i<n;++i) Need(dense.data()[i] == uint32_t(f.Contains(input.data()[i])), "Dense mismatch");
  input.CheckPrefix(); compact.CheckPrefix(); dense.CheckPrefix();
  return checksum;
}
template<class T> void Check(const stage::Geometry& g, bool nearby) {
  using P=typename T::Public;
  P::Configure();
  typename T::Dynamic dynamic(g.constructor_bits);
  typename T::Static statik(g.constructor_bits);
  P artifact(g.constructor_bits);
  artifact.CheckConfiguration();
  // Independently inspect the actual original public metadata. Its mode and
  // size must agree with the planner; never silently relabel an over-allocation.
  typename T::Facade metadata(g.constructor_bits,8,
      g.block_bytes / (std::is_same_v<typename T::Facade,dtl::bbf_32> ? 4 : 8),
      g.block_bytes == 8 ? 1 : 8);
  const auto name = metadata.name();
  Need(name.find(std::string("\"addr\":\"")+stage::AddressName(g.address)+"\"")!=std::string::npos,"actual address mismatch");
  Need(metadata.size_in_bytes()==g.logical_bytes,"actual metadata size mismatch");
  Need(dynamic.logical_bytes()==g.logical_bytes && statik.logical_bytes()==g.logical_bytes && artifact.logical_bytes()==g.logical_bytes,"logical allocation mismatch");
  Need(dynamic.backing_bytes()==g.backing_bytes && statik.backing_bytes()==g.backing_bytes && artifact.backing_bytes()==g.backing_bytes,"physical allocation mismatch");
  old::Raw32Workload w(65536,8192,0,50,42);
  const size_t lengths[]={0,1,3,4,7,8,15,16,31,32,63,64,65,127,128,129,4096,4097,4127};
  for(size_t n:lengths) {
    const auto a=Query(dynamic,w.query.data(),n),b=Query(statik,w.query.data(),n),c=Query(artifact,w.query.data(),n);
    Need(a==b && a==c,"empty bitmap API disagreement");
  }
  dynamic.Insert(0,nullptr); statik.Insert(0,nullptr); artifact.Insert(0,nullptr);
  dynamic.Insert(w.inserted.size(),w.inserted.data());
  statik.Insert(w.inserted.size(),w.inserted.data());
  artifact.Insert(w.inserted.size(),w.inserted.data());
  const std::array<uint32_t,5> repeated{w.inserted[0],w.inserted[0],w.inserted[1],0,UINT32_MAX};
  dynamic.Insert(repeated.size(),repeated.data()); statik.Insert(repeated.size(),repeated.data()); artifact.Insert(repeated.size(),repeated.data());
  Need(!std::memcmp(dynamic.data(),statik.data(),g.logical_bytes) && !std::memcmp(dynamic.data(),artifact.data(),g.logical_bytes),"full bitmap mismatch");
  for(auto key:w.inserted) Need(dynamic.Contains(key)&&statik.Contains(key)&&artifact.Contains(key),"false negative");
  for(size_t i=g.logical_bytes;i<g.backing_bytes;++i) {
    Need(reinterpret_cast<const uint8_t*>(dynamic.data())[i]==0 && reinterpret_cast<const uint8_t*>(statik.data())[i]==0 && reinterpret_cast<const uint8_t*>(artifact.data())[i]==0,"padding unexpectedly written");
  }
  uint64_t bitmap_digest=UINT64_C(14695981039346656037);
  const auto* bytes=reinterpret_cast<const uint8_t*>(artifact.data());
  for(size_t i=0;i<g.logical_bytes;++i) bitmap_digest=(bitmap_digest^bytes[i])*UINT64_C(1099511628211);
  uint64_t digest=UINT64_C(14695981039346656037);
  for(size_t offset=0;offset<8;++offset) for(size_t n=0;n<=131;++n) {
    const auto a=Query(dynamic,w.query.data()+offset,n),b=Query(statik,w.query.data()+offset,n),c=Query(artifact,w.query.data()+offset,n);
    Need(a==b && a==c,"tail API disagreement"); digest=(digest^a)*UINT64_C(1099511628211);
  }
  for(size_t n:lengths) {
    Need(Query(dynamic,w.inserted.data(),n)==Query(statik,w.inserted.data(),n),"all-hit API disagreement");
    Need(Query(statik,w.inserted.data(),n)==Query(artifact,w.inserted.data(),n),"all-hit public disagreement");
  }
  Need(dynamic.Dense(0,nullptr,nullptr,nullptr)==0 && statik.Dense(0,nullptr,nullptr,nullptr)==0 && artifact.Dense(0,nullptr,nullptr,nullptr)==0,"zero API");
  std::cout<<"{\"status\":\"supported\",\"policy\":\""<<(nearby?"nearby_odd":"original")<<"\",\"budget_bytes\":"<<g.budget_bytes<<",\"constructor_bits\":"<<g.constructor_bits
      <<",\"logical_bytes\":"<<g.logical_bytes<<",\"backing_bytes\":"<<g.backing_bytes
      <<",\"block_count\":"<<g.block_count<<",\"address\":\""<<stage::AddressName(g.address)
      <<"\",\"digest\":"<<digest<<",\"bitmap_digest\":"<<bitmap_digest<<",\"upstream_metadata\":"<<name<<"}\n";
}
template<class Word,unsigned W,unsigned S,unsigned U> void Dispatch(const stage::Geometry& g, bool nearby) {
  if(g.address==dtl::block_addressing::POWER_OF_TWO)
    Check<Types<Word,W,S,8,U,dtl::block_addressing::POWER_OF_TWO>>(g,nearby);
  else Check<Types<Word,W,S,8,U,dtl::block_addressing::MAGIC>>(g,nearby);
}
int main(int argc,char** argv) try {
  if(argc!=5) throw std::invalid_argument("geometry_check sector32-u1|u2|u4 or sector64-u1|u2|u4 or register64-u0 key_power bpk original|nearby_odd");
  const std::string which=argv[1], policy=argv[4];
  Need(policy=="original" || policy=="nearby_odd","unregistered capacity policy");
  const bool nearby=policy=="nearby_odd";
  const std::array<std::string,7> configs{"sector32-u1","sector32-u2","sector32-u4","sector64-u1","sector64-u2","sector64-u4","register64-u0"};
  Need(std::find(configs.begin(),configs.end(),which)!=configs.end(),"unregistered API configuration");
  size_t used=0;const unsigned power=std::stoul(argv[2],&used);Need(used==std::strlen(argv[2]),"invalid key power");
  const unsigned bpk=std::stoul(argv[3],&used);Need(used==std::strlen(argv[3]),"invalid bpk");
  Need((power==16||power==25) && (bpk==12||bpk==16||bpk==24||bpk==32),"unregistered geometry");
  const uint32_t block=which=="register64-u0"?8:which.rfind("sector32-",0)==0?32:64;
  Need(!nearby || bpk==12 || bpk==24,"nearby policy restricted to non-power-of-two caps");
  Need(!vldb_nearby::Plan(128,8).has_value(),"empty finite odd window must remain unsupported");
  for(const auto invalid:std::array<std::array<size_t,2>,5>{{{{0,8}},{{127,8}},{{size_t{1}<<29,8}},{{4096,3}},{{4096,128}}}}) {
    bool rejected=false;try { (void)vldb_nearby::Plan(invalid[0],invalid[1]); }
    catch(const std::invalid_argument&) { rejected=true; }
    Need(rejected,"invalid geometry accepted");
  }
  const size_t budget=(size_t{1}<<power)*bpk/8;
  const auto selected=nearby?vldb_nearby::Plan(budget,block):std::optional<stage::Geometry>(stage::Plan(budget,block));
  if(!selected) {
    std::cout<<"{\"status\":\"unsupported\",\"policy\":\"nearby_odd\",\"budget_bytes\":"<<budget<<",\"block_bytes\":"<<block<<",\"maximum_blocks\":"<<vldb_nearby::Maximum(budget,block)<<",\"lower_blocks\":"<<vldb_nearby::Lower(vldb_nearby::Maximum(budget,block))<<"}\n";
    return 0;
  }
  const auto& g=*selected;
  CheckPlanner(g,nearby);

  if(which=="sector32-u1") Dispatch<uint32_t,8,8,1>(g,nearby);
  else if(which=="sector32-u2") Dispatch<uint32_t,8,8,2>(g,nearby);
  else if(which=="sector32-u4") Dispatch<uint32_t,8,8,4>(g,nearby);
  else if(which=="sector64-u1") Dispatch<uint64_t,8,8,1>(g,nearby);
  else if(which=="sector64-u2") Dispatch<uint64_t,8,8,2>(g,nearby);
  else if(which=="sector64-u4") Dispatch<uint64_t,8,8,4>(g,nearby);
  else if(which=="register64-u0") Dispatch<uint64_t,1,1,0>(g,nearby);
  else throw std::invalid_argument("unregistered public API configuration");
  return 0;
} catch(const std::exception& e) { std::cerr<<e.what()<<'\n';return 2; }
