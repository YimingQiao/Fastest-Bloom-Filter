#pragma once
#include "query_loop.hpp"
#include "../vldb-original-external/raw32_workload.hpp"
#include <array>
#include <chrono>
#include <cmath>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace raw32_stage3 {
using Mode=vldb_stage2::QueryMode;
inline void Need(bool ok,const char* message) { if(!ok) throw std::runtime_error(message); }
inline uint64_t Integer(const char* text) {
  size_t count=0;const std::string value=text;
  if(value.empty() || value.find_first_not_of("0123456789")!=std::string::npos) throw std::invalid_argument("unsigned decimal argument required");
  const auto result=std::stoull(value,&count);Need(count==value.size(),"trailing argument bytes");return result;
}
struct Args {
  std::string action,name;
  uint32_t power=0,bpk=0,qpower=0,hit=0,seed=0,calpower=0,repeats=0;
  size_t n() const { return size_t{1}<<power; }
  size_t q() const { return size_t{1}<<qpower; }
  size_t cal() const { return calpower?size_t{1}<<calpower:0; }
};
inline Args Parse(int argc,char** argv) {
  Need(argc==5 || argc==10,"worker --plan FILTER NPOWER CAP or --check|--check-bad-output|--measure FILTER NPOWER CAP QPOWER HIT SEED CALPOWER REPEATS");
  Args a;a.action=argv[1];a.name=argv[2];
  const auto p=Integer(argv[3]),b=Integer(argv[4]);
  Need(p>=6 && p<=25 && (b==12||b==16||b==24||b==32),"unsupported item count/cap");
  a.power=p;a.bpk=b;
  if(argc==5) { Need(a.action=="--plan","missing workload arguments");return a; }
  Need(a.action=="--check" || a.action=="--check-bad-output" || a.action=="--measure","unknown action");
  const auto q=Integer(argv[5]),hit=Integer(argv[6]),seed=Integer(argv[7]),cal=Integer(argv[8]),repeats=Integer(argv[9]);
  Need(q>=8 && q<=24 && hit<=100 && seed<=UINT32_MAX && cal<=27 && repeats<=60,"workload argument bounds");
  Need(a.action=="--measure"?(repeats>0 && repeats%6==0):repeats==0,"check requires zero timing repetitions; measurement requires complete six-trial blocks");
  a.qpower=q;a.hit=hit;a.seed=seed;a.calpower=cal;a.repeats=repeats;
  const uint64_t present=(a.q()/100)*a.hit+std::min<uint64_t>(a.q()%100,a.hit);
  Need(a.n()+a.q()-present+a.cal()<=(UINT64_C(1)<<32),"raw-u32 domains overlap");
  return a;
}
struct Geometry {
  size_t budget=0,bytes=0,logical=0,unit=0,units=0,argument=0;
  int probes=0;
  std::string kind,probe_policy="fixed",address="range",origin="external",surface;
  std::string metadata="{}";
};
using Row=std::vector<std::pair<std::string,std::string>>;
inline std::string Number(double x) {
  if(std::isnan(x))return "nan";
  std::ostringstream out;out<<std::setprecision(17)<<x;return out.str();
}
inline void Add(Row& row,const char* key,const std::string& value) { row.emplace_back(key,value); }
template<class T> void Add(Row& row,const char* key,T value) { row.emplace_back(key,std::to_string(value)); }
inline std::string Csv(const std::string& s) {
  if(s.find_first_of(",\"\n\r")==std::string::npos)return s;
  std::string result="\"";for(char c:s){result+=c;if(c=='\"')result+='\"';}return result+'\"';
}
inline void Print(const Row& row) {
  for(size_t i=0;i<row.size();++i)std::cout<<(i?",":"")<<Csv(row[i].first);std::cout<<'\n';
  for(size_t i=0;i<row.size();++i)std::cout<<(i?",":"")<<Csv(row[i].second);std::cout<<'\n';
}
inline Row Describe(const char* worker,const Args& a,const Geometry& g) {
  Row r;Add(r,"worker",std::string(worker));Add(r,"filter",a.name);Add(r,"surface",g.surface);Add(r,"implementation_origin",g.origin);
  Add(r,"key_domain",std::string("raw_u32"));Add(r,"keys",a.n());Add(r,"requested_bpk",a.bpk);Add(r,"budget_bytes",g.budget);
  Add(r,"filter_bytes",g.bytes);Add(r,"logical_bytes",g.logical);Add(r,"unit_bytes",g.unit);Add(r,"unit_count",g.units);
  Add(r,"constructor_argument",g.argument);Add(r,"effective_probes",g.probes);Add(r,"probe_policy",g.probe_policy);
  Add(r,"geometry_kind",g.kind);Add(r,"address",g.address);Add(r,"public_metadata",g.metadata);return r;
}
inline uint64_t HashWord(uint64_t state,uint32_t word) {
  for(unsigned b=0;b<4;++b) state=(state^((word>>(b*8))&255))*UINT64_C(1099511628211);
  return state;
}
inline uint64_t Digest(const uint32_t* data,size_t n) {
  uint64_t state=UINT64_C(14695981039346656037);
  for(size_t i=0;i<n;++i)state=HashWord(state,data[i]);return state;
}
struct GuardedOutput {
  static constexpr uint32_t Guard=UINT32_C(0xdeadbeef),Poison=UINT32_C(0xfeedface);
  std::vector<uint32_t> storage;size_t n;
  explicit GuardedOutput(size_t count):storage(count+32,Guard),n(count) { Reset(); }
  uint32_t* data(){return storage.data()+16;}
  void Reset(){std::fill(storage.begin(),storage.end(),Guard);std::fill(data(),data()+n,Poison);}
  void CheckGuards() const {
    Need(std::all_of(storage.begin(),storage.begin()+16,[](uint32_t x){return x==Guard;}),"left output guard");
    Need(std::all_of(storage.end()-16,storage.end(),[](uint32_t x){return x==Guard;}),"right output guard");
  }
  void Check(const uint32_t* expected) const {
    CheckGuards();
    for(size_t i=0;i<n;++i)Need(storage[i+16]<=1 && storage[i+16]==expected[i],"full output mismatch");
  }
};
inline volatile uint64_t sink=0;
inline std::string Trials(const std::vector<double>& values) {
  if(values.empty())return "nan";
  std::string s;for(double x:values){if(!s.empty())s+='|';s+=Number(x);}return s;
}
inline double Median(std::vector<double> values) {
  if(values.empty())return std::numeric_limits<double>::quiet_NaN();
  std::sort(values.begin(),values.end());const size_t m=values.size()/2;
  return values.size()%2?values[m]:(values[m-1]+values[m])/2;
}
// One coarse function-pointer boundary around a WHOLE query array for every
// candidate. The pointed-to typed Query retains public-single inlining inside
// its loop. Shared validation/CSV/timer code is emitted once per executable.
struct AnyFilter {
  void* object;size_t object_bytes;
  Geometry (*info)(void*);
  void (*insert)(void*,uint32_t,const uint32_t*);
  void (*prepare)(void*,Mode);
  bool (*single)(void*,uint32_t);
  void (*dense)(void*,uint32_t,const uint32_t*,uint32_t*);
  void (*query)(void*,Mode,size_t,const uint32_t*,uint32_t*);
  size_t (*scratch)(void*),(*build_scratch)(void*),(*filter_build_scratch)(void*);
  template<class F>static AnyFilter Bind(F& f) {
    return {&f,sizeof(F),[](void* p){return static_cast<F*>(p)->Info();},
      [](void* p,uint32_t n,const uint32_t* h){static_cast<F*>(p)->Insert(n,h);},
      [](void* p,Mode mode){static_cast<F*>(p)->Prepare(mode);},
      [](void* p,uint32_t h){return static_cast<F*>(p)->Single(h);},
      [](void* p,uint32_t n,const uint32_t* h,uint32_t* out){static_cast<F*>(p)->Dense(n,h,out);},
      [](void* p,Mode mode,size_t n,const uint32_t* h,uint32_t* out){vldb_stage2::Query(*static_cast<F*>(p),mode,n,h,out);},
      [](void* p){return static_cast<F*>(p)->QueryScratchBytes();},
      [](void* p){return static_cast<F*>(p)->BuildHashScratchBytes();},
      [](void* p){return static_cast<F*>(p)->FilterBuildScratchBytes();}};
  }
  Geometry Info()const{return info(object);}
  void Insert(uint32_t n,const uint32_t* h)const{insert(object,n,h);}
  void Prepare(Mode mode)const{prepare(object,mode);}
  bool Single(uint32_t key)const{return single(object,key);}
  void Dense(uint32_t n,const uint32_t* h,uint32_t* out)const{dense(object,n,h,out);}
  void Query(Mode mode,size_t n,const uint32_t* h,uint32_t* out)const{query(object,mode,n,h,out);}
  size_t QueryScratchBytes()const{return scratch(object);}
  size_t BuildHashScratchBytes()const{return build_scratch(object);}
  size_t FilterBuildScratchBytes()const{return filter_build_scratch(object);}
};
__attribute__((noinline)) inline int RunObject(const char* worker,const Args& a,const AnyFilter& f) {
  const Geometry g=f.Info();
  Need(g.bytes>0 && g.bytes<=g.budget && g.logical<=g.bytes,"actual allocation exceeded cap");
  Row row=Describe(worker,a,g);
  if(a.action=="--plan"){Print(row);return 0;}
  const vldb_external::Raw32Workload w(a.n(),a.q(),a.cal(),a.hit,a.seed);
  const uint64_t inserted_digest=Digest(w.inserted.data(),w.inserted.size());
  const uint64_t query_digest=Digest(w.query.data(),w.query.size());
  const uint64_t calibration_digest=Digest(w.calibration.data(),w.calibration.size());
  f.Insert(w.inserted.size(),w.inserted.data());
  Need(Digest(w.inserted.data(),w.inserted.size())==inserted_digest,"input mutated by build");
  // The no-FN check covers every inserted key, not a sampled prefix.
  f.Prepare(Mode::DenseBatch4096);std::vector<uint32_t> ones(4096,1);
  for(size_t i=0;i<w.inserted.size();i+=4096){const auto n=std::min<size_t>(4096,w.inserted.size()-i);GuardedOutput out(n);f.Dense(n,w.inserted.data()+i,out.data());out.Check(ones.data());}
  f.Prepare(Mode::PublicSingle);
  std::vector<uint32_t> expected(w.query.size());
  f.Query(Mode::PublicSingle,w.query.size(),w.query.data(),expected.data());
  uint64_t false_positives=0;
  for(size_t i=0;i<expected.size();++i){Need(expected[i]<=1,"nonboolean public singleton");if(w.present[i])Need(expected[i]==1,"query false negative");else false_positives+=expected[i];}
  const uint64_t expected_digest=Digest(expected.data(),expected.size());
  GuardedOutput out(w.query.size());
  // All three warmups use the same canonical dense output before any timer.
  for(unsigned mode=0;mode<3;++mode){f.Prepare(static_cast<Mode>(mode));out.Reset();f.Query(static_cast<Mode>(mode),w.query.size(),w.query.data(),out.data());out.Check(expected.data());}
  if(a.action!="--measure") {
    f.Prepare(Mode::DenseBatch4096);
    for(size_t offset=0;offset<4;++offset)for(size_t n=0;n<=131;++n){GuardedOutput tail(n);f.Dense(n,w.query.data()+offset,tail.data());tail.Check(expected.data()+offset);}
    for(size_t offset=0;offset<4;++offset)for(size_t n:{4095,4096,4097,4127})if(n+offset<=w.query.size()) {
      GuardedOutput tail(n);f.Query(Mode::DenseBatch4096,n,w.query.data()+offset,tail.data());tail.Check(expected.data()+offset);
    }
  }
  std::array<std::vector<double>,3> times;
  std::array<size_t,3> scratch{};
  std::string order;
  for(unsigned trial=0;trial<a.repeats;++trial) {
    if(trial)order+='|';
    for(unsigned slot=0;slot<3;++slot) {
      const unsigned mode=vldb_stage2::Phase(a.seed,trial,slot);order+=char('0'+mode);
      f.Prepare(static_cast<Mode>(mode));scratch[mode]=f.QueryScratchBytes();out.Reset();
      const auto begin=std::chrono::steady_clock::now();
      f.Query(static_cast<Mode>(mode),w.query.size(),w.query.data(),out.data());
      const auto end=std::chrono::steady_clock::now();
      times[mode].push_back(std::chrono::duration<double,std::nano>(end-begin).count()/w.query.size());
      out.Check(expected.data());Need(Digest(out.data(),w.query.size())==expected_digest,"timed checksum mismatch");
      Need(Digest(w.query.data(),w.query.size())==query_digest,"query input mutated");sink=expected_digest;
    }
  }
  if(a.action=="--check-bad-output"){out.data()[0]=2;out.Check(expected.data());throw std::runtime_error("fault injection was not detected");}
  // Independent negatives, never pooled with the mixed timed query stream.
  uint64_t calibration_fp=0;f.Prepare(Mode::DenseBatch4096);
  for(size_t i=0;i<w.calibration.size();i+=4096){const auto n=std::min<size_t>(4096,w.calibration.size()-i);GuardedOutput result(n);f.Dense(n,w.calibration.data()+i,result.data());
    result.CheckGuards();
    for(size_t j=0;j<n;++j){Need(result.data()[j]<=1,"nonboolean calibration answer");calibration_fp+=result.data()[j];}
    // Public singleton calibration parity is correctness-only, not an extra
    // full calibration pass in the future performance matrix.
    if(a.action!="--measure")for(size_t j=0;j<n;++j)Need(result.data()[j]==uint32_t(f.Single(w.calibration[i+j])),"calibration API disagreement");
  }
  Need(Digest(w.calibration.data(),w.calibration.size())==calibration_digest,"calibration input mutated");
  Need(Digest(w.query.data(),w.query.size())==query_digest,"query input mutated outside timing");
  Need(Digest(w.inserted.data(),w.inserted.size())==inserted_digest,"inserted input mutated after build");
  for(unsigned mode=0;mode<3;++mode){f.Prepare(static_cast<Mode>(mode));scratch[mode]=f.QueryScratchBytes();}
  Add(row,"queries",w.query.size());Add(row,"seed",a.seed);Add(row,"hit_percent",a.hit);Add(row,"present_queries",w.present_count);Add(row,"absent_queries",w.absent_count);
  Add(row,"calibration_absent_queries",w.calibration.size());Add(row,"calibration_false_positives",calibration_fp);Add(row,"false_positives",false_positives);Add(row,"result_checksum",expected_digest);
  Add(row,"inserted_checksum",inserted_digest);Add(row,"query_checksum",query_digest);Add(row,"calibration_checksum",calibration_digest);
  Add(row,"repeats",a.repeats);Add(row,"query_phase_order",order.empty()?std::string("untimed"):order);
  const char* prefix[]={"raw_single","raw_batch1","raw_batch4096"};
  for(unsigned mode=0;mode<3;++mode){const std::string key=prefix[mode];Add(row,(key+"_ns").c_str(),Number(Median(times[mode])));Add(row,(key+"_trials_ns").c_str(),Trials(times[mode]));
    Add(row,(key+"_min_ns").c_str(),Number(times[mode].empty()?NAN:*std::min_element(times[mode].begin(),times[mode].end())));
    Add(row,(key+"_max_ns").c_str(),Number(times[mode].empty()?NAN:*std::max_element(times[mode].begin(),times[mode].end())));Add(row,(key+"_scratch_bytes").c_str(),scratch[mode]);}
  Add(row,"build_repeats",0);for(const char* key:{"insert_ns","allocate_insert_ns","hash_insert_ns","allocate_hash_insert_ns"})Add(row,key,std::string("nan"));
  Add(row,"build_hash_scratch_bytes",f.BuildHashScratchBytes());Add(row,"filter_build_scratch_bytes",f.FilterBuildScratchBytes());Add(row,"adapter_object_bytes",f.object_bytes);
  Print(row);return 0;
}
template<class Filter> int Run(const char* worker,const Args& a) {
  Filter filter(a.n(),a.bpk);const auto erased=AnyFilter::Bind(filter);
  return RunObject(worker,a,erased);
}
} // namespace raw32_stage3
