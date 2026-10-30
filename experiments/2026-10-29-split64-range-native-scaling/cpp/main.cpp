#include "native/parallel_layout_bloom.h"
#include "range/parallel_split64_range.h"
#include "placement.hpp"
#include <array>
#include <chrono>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <set>
#include <sstream>
using namespace bloom_filters;
using Clock=std::chrono::steady_clock;
static volatile uint64_t sink;
static constexpr const char *metrics[]={"serial_insert","parallel_insert","serial_allocate_insert","parallel_allocate_insert","serial_lookup","parallel_lookup"};
struct RNG {uint64_t state; uint64_t next(){uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}};
template<class T>void Shuffle(std::vector<T>&v,RNG&r){for(size_t i=v.size();i>1;--i)std::swap(v[i-1],v[r.next()%i]);}
static void Require(bool ok,const char *message){if(!ok)throw std::runtime_error(message);}
static void Affinity(const std::vector<int>&cpus){cpu_set_t set;CPU_ZERO(&set);for(int cpu:cpus)CPU_SET(cpu,&set);if(sched_setaffinity(0,sizeof(set),&set))throw std::runtime_error("set affinity failed");}
static size_t QueryWorkers(size_t n,size_t t){return n<(1u<<14)?1:std::max<size_t>(1,std::min({t,n/4096,size_t{1024}}));}
static double Nanos(Clock::time_point a,Clock::time_point b,size_t n){return std::chrono::duration<double,std::nano>(b-a).count()/n;}
static double Median(std::vector<double>v){std::sort(v.begin(),v.end());return v.size()%2?v[v.size()/2]:(v[v.size()/2-1]+v[v.size()/2])/2;}
struct Config {size_t n,q,threads,repeats,calibration;uint32_t cap;uint64_t seed,base;unsigned hit;std::vector<int>cpus;};
struct Data {std::vector<uint64_t>inserted,query;std::vector<uint8_t>truth;};
static Data Workload(Config&c,RNG&r){
 c.base=r.next()%((uint64_t{1}<<32)-c.n-c.q);Data d;d.inserted.resize(c.n);d.query.resize(c.q);d.truth.resize(c.q);
 for(size_t i=0;i<c.n;++i)d.inserted[i]=MurmurHash64(c.base+i);Shuffle(d.inserted,r);
 for(size_t i=0;i<c.q;++i){d.truth[i]=i%100<c.hit;d.query[i]=MurmurHash64(c.base+(d.truth[i]?r.next()%c.n:c.n+i));}
 for(size_t i=c.q;i>1;--i){size_t j=r.next()%i;std::swap(d.query[i-1],d.query[j]);std::swap(d.truth[i-1],d.truth[j]);}return d;
}
template<bool Range>using Filter=std::conditional_t<Range,ParallelSplit64RangeBloomFilter,ParallelSplit64BloomFilter>;
template<bool Range>static Filter<Range> Make(const Config&c){
 if constexpr(Range)return Filter<Range>(RangeBytes{c.n*c.cap/8});
 else {Require(c.cap==16||c.cap==32,"Split control supports exact16/32 only");return Filter<Range>(c.n,c.cap/2);}
}
template<class BF>static void Insert(BF&bf,const Data&d,const Config&c,bool parallel){if(parallel)bf.InsertParallel(d.inserted.size(),d.inserted.data(),c.threads);else bf.Insert(d.inserted.size(),d.inserted.data());}
template<class BF>static void Lookup(const BF&bf,const Data&d,const Config&c,bool parallel,uint32_t*out){if(parallel)bf.LookupParallel(d.query.size(),d.query.data(),out,c.threads);else bf.Lookup(d.query.size(),d.query.data(),out);}
static void Guards(const std::vector<uint32_t>&out,size_t n){for(size_t i=0;i<16;++i)Require(out[i]==0xfeed&&out[16+n+i]==0xfeed,"dense output guard changed");}
template<class BF>static void ValidateBuilt(const BF&bf,const Data&d,const std::vector<uint32_t>&expected,std::vector<uint32_t>&out){
 std::array<uint32_t,4096>check;
 for(size_t i=0;i<d.inserted.size();i+=check.size()){size_t len=std::min(check.size(),d.inserted.size()-i);std::fill(check.begin(),check.end(),0xfeed);bf.Lookup(len,d.inserted.data()+i,check.data());for(size_t j=0;j<len;++j)Require(check[j]==1,"inserted false negative");}
 std::fill(out.begin(),out.end(),0xfeed);bf.Lookup(d.query.size(),d.query.data(),out.data()+16);Guards(out,d.query.size());Require(std::equal(expected.begin(),expected.end(),out.begin()+16),"full built bitmap answers differ");
}
template<bool Range>static void Run(const Data&d,const Config&c){
 const std::vector<int>serial{c.cpus.front()};std::vector<uint32_t>expected(c.q),out(c.q+32,0xfeed);size_t bytes=0,bw=0,qw=QueryWorkers(c.q,c.threads),scratch=0;
 // Only dense oracle answers survive this scope; its bitmap is destroyed before any timed build.
 {Affinity(serial);auto oracle=Make<Range>(c);bytes=oracle.SizeInBytes();Require(bytes==c.n*c.cap/8,"wrong actual capacity");bw=oracle.BuildWorkers(c.n,c.threads);scratch=oracle.BuildScratchBytes(c.n,c.threads);oracle.Insert(c.n,d.inserted.data());oracle.Lookup(c.q,d.query.data(),expected.data());ValidateBuilt(oracle,d,expected,out);}
 std::array<std::vector<double>,6>times;static constexpr unsigned schedule[4][4]={{0,1,3,2},{1,2,0,3},{2,3,1,0},{3,0,2,1}};
 for(size_t repeat=0;repeat<c.repeats;++repeat){
  for(unsigned mode:schedule[(repeat+c.seed%4)%4]){
   const bool parallel=mode%2;Affinity(serial);
   if(mode<2){auto fresh=Make<Range>(c);Affinity(parallel?c.cpus:serial);auto start=Clock::now();Insert(fresh,d,c,parallel);auto stop=Clock::now();Affinity(serial);times[mode].push_back(Nanos(start,stop,c.n));Require(fresh.SizeInBytes()==bytes,"fresh allocation changed");ValidateBuilt(fresh,d,expected,out);}
   else {Affinity(parallel?c.cpus:serial);auto start=Clock::now();auto fresh=Make<Range>(c);Insert(fresh,d,c,parallel);auto stop=Clock::now();Affinity(serial);times[mode].push_back(Nanos(start,stop,c.n));Require(fresh.SizeInBytes()==bytes,"fresh allocation changed");ValidateBuilt(fresh,d,expected,out);}
  }
 }
 // Query bitmap is allocated only after all disjoint timed-build lifetimes.
 Affinity(serial);auto bf=Make<Range>(c);Require(bf.SizeInBytes()==bytes,"canonical allocation changed");bf.Insert(c.n,d.inserted.data());ValidateBuilt(bf,d,expected,out);
 for(bool parallel:{false,true}){std::fill(out.begin(),out.end(),0xfeed);Affinity(parallel?c.cpus:serial);Lookup(bf,d,c,parallel,out.data()+16);Affinity(serial);Guards(out,c.q);Require(std::equal(expected.begin(),expected.end(),out.begin()+16),"warm-up dense mismatch");}
 for(size_t repeat=0;repeat<c.repeats;++repeat)for(size_t phase=0;phase<2;++phase){bool parallel=(phase+repeat+c.seed%2)%2;std::fill(out.begin(),out.end(),0xfeed);Affinity(parallel?c.cpus:serial);auto start=Clock::now();Lookup(bf,d,c,parallel,out.data()+16);auto stop=Clock::now();Affinity(serial);times[4+parallel].push_back(Nanos(start,stop,c.q));Guards(out,c.q);Require(std::equal(expected.begin(),expected.end(),out.begin()+16),"timed dense mismatch");sink=std::accumulate(out.begin()+16,out.begin()+16+c.q,uint64_t{0});}
 size_t present=0,fp=0;uint64_t checksum=14695981039346656037ULL;for(size_t i=0;i<c.q;++i){Require(expected[i]<=1&&(!d.truth[i]||expected[i]==1),"invalid expected output");present+=d.truth[i];if(!d.truth[i])fp+=expected[i];checksum=(checksum^expected[i])*1099511628211ULL;}
 std::array<uint64_t,4096>hashes;std::array<uint32_t,4096>answers;size_t calfp=0;
 for(size_t i=0;i<c.calibration;i+=hashes.size()){size_t len=std::min(hashes.size(),c.calibration-i);for(size_t j=0;j<len;++j)hashes[j]=MurmurHash64(c.base+c.n+c.q+i+j);std::fill(answers.begin(),answers.end(),0xfeed);bf.Lookup(len,hashes.data(),answers.data());for(size_t j=0;j<len;++j){Require(answers[j]<=1,"bad calibration output");calfp+=answers[j];}}
 std::cout<<std::setprecision(17)<<"cpp,"<<(Range?"Split64Range":"Split64")<<','<<c.n<<','<<c.q<<','<<c.cap<<','<<bytes<<','<<8.0*bytes/c.n<<','<<c.threads<<','<<bw<<','<<qw<<','<<scratch<<','<<c.repeats<<','<<c.seed<<','<<c.hit<<','<<present<<','<<c.q-present<<','<<fp<<','<<checksum<<','<<c.calibration<<','<<calfp<<','<<c.base<<",prehashed64,caller_worker0,"<<(bw-1)<<','<<(qw-1)<<",whole_array_native_api,build_williams4_query_alternating,insert_cpu3_allocate_allowed_set";
 for(const auto&v:times){std::cout<<','<<Median(v)<<','<<*std::min_element(v.begin(),v.end())<<','<<*std::max_element(v.begin(),v.end())<<',';for(size_t i=0;i<v.size();++i){if(i)std::cout<<'|';std::cout<<v[i];}}
 std::cout<<'\n';
}
int main(int argc,char**argv){try{
 Require(argc==11,"POWER CAP QPOWER THREADS REPEATS SEED HIT CALPOWER FILTERS CPUS required");auto number=[&](size_t i){std::string x=argv[i];Require(!x.empty()&&x.find_first_not_of("0123456789")==std::string::npos,"unsigned integer required");return std::stoull(x);};
 auto kp=number(1),cap=number(2),qp=number(3),threads=number(4),reps=number(5),seed=number(6),hit=number(7),cp=number(8);
 Require(kp>=6&&kp<=25&&qp>=12&&qp<=27&&(cap==16||cap==24||cap==32)&&threads>=1&&threads<=8&&reps>=4&&reps<=32&&reps%4==0&&hit<=100&&cp>=12&&cp<=27,"unsupported workload");
 const auto cpus=external_parallel::ParseCpus(argv[10],threads);Require(cpus.front()==3,"serial control requiresCPU3");
 std::set<std::string>selected;std::stringstream input(argv[9]);std::string name;while(std::getline(input,name,','))Require((name=="Split64"||name=="Split64Range")&&selected.insert(name).second,"unknown/duplicate family");Require(!selected.empty()&&std::string(argv[9]).back()!=',',"empty family");Require(cap!=24||!selected.count("Split64"),"Split24 duplicates Split16 and is outside fixed selection");
 Config c{size_t{1}<<kp,size_t{1}<<qp,size_t(threads),size_t(reps),size_t{1}<<cp,uint32_t(cap),seed,0,unsigned(hit),cpus};Affinity({3});RNG rng{seed};auto d=Workload(c,rng);std::vector<std::string>order;for(const char*family:{"Split64","Split64Range"})if(selected.count(family))order.push_back(family);Shuffle(order,rng);
 std::cout<<"language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,core_budget,build_workers,query_workers,estimated_build_scratch_bytes,repeats,seed,hit_percent,present_queries,absent_queries,false_positives,result_checksum,calibration_absent_queries,calibration_false_positives,key_base,input_mode,scheduler_model,build_spawned_workers_per_pass,query_spawned_workers,query_contract,phase_order,parallel_first_touch";
 for(auto metric:metrics)for(const char*suffix:{"_ns","_min_ns","_max_ns","_trials_ns"})std::cout<<','<<metric<<suffix;std::cout<<'\n';
 for(const auto&family:order)if(family=="Split64")Run<false>(d,c);else Run<true>(d,c);
 }catch(const std::exception&e){std::cerr<<e.what()<<'\n';return 1;}}
