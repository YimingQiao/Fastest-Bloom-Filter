#include "bindings.hpp"
#include "placement.hpp"
#include <algorithm>
#include <array>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <limits>
#include <type_traits>

namespace {
using Clock = std::chrono::steady_clock;
constexpr size_t Block = 4096, Queries = 32771;
constexpr uint32_t Guard = 0xfeed;
constexpr unsigned Schedule[4][3] = {{0,1,2},{2,1,0},{0,2,1},{1,2,0}};
constexpr const char* Arms[3] = {"serial", "control", "candidate"};
void Need(bool ok, const char* message) { if (!ok) throw std::runtime_error(message); }
void Affinity(const std::vector<int>& cpus) {
    cpu_set_t set; CPU_ZERO(&set); for (int cpu : cpus) CPU_SET(cpu, &set);
    Need(sched_setaffinity(0, sizeof(set), &set) == 0, "set affinity failed");
}
double Ns(Clock::time_point begin, Clock::time_point end) {
    return std::chrono::duration<double, std::nano>(end-begin).count();
}
uint64_t Hash(uint64_t index) {
    uint64_t z = 0x243f6a8885a308d3ULL + (index+1)*0x9e3779b97f4a7c15ULL;
    z = (z^(z>>30))*0xbf58476d1ce4e5b9ULL;
    z = (z^(z>>27))*0x94d049bb133111ebULL;
    return z^(z>>31);
}
struct Case {
    size_t id, bytes, n, requested, history; uint64_t seed, base;
    bool hotspot; std::vector<int> cpus;
};
Case GetCase(bool range, size_t id, size_t request, uint64_t seed, std::vector<int> cpus) {
    const size_t large = range ? 100663296 : 67108864;
    const std::array<std::array<size_t,4>,6> geometry = {{{262144,65536,0,0},
        {262144,65537,0,0},{262144,65536,131072,1},
        {range?262208u:524288u,65536,0,0},{large,65536,0,0},{large,65536,large/2,1}}};
    const auto& g = geometry.at(id);
    return {id,g[0],g[1],request,g[2],seed,seed<<42,g[3]!=0,std::move(cpus)};
}
template<bool Range, bool After> using Filter = typename NativeBinding<Range,After>::Type;
template<bool Range, bool After> Filter<Range,After> Make(const Case& c) {
    return NativeBinding<Range,After>::Make(c.bytes);
}
struct Data { std::vector<uint64_t> batch, query; };
Data Workload(const Case& c) {
    Data d{std::vector<uint64_t>(c.n),std::vector<uint64_t>(Queries)};
    for(size_t i=0;i<c.n;++i) {
        const uint64_t h=Hash(c.base+(uint64_t{1}<<40)+i);
        d.batch[i]=c.hotspot ? h&0xffffffffULL : h;
    }
    for(size_t i=0;i<Queries;++i) d.query[i]=Hash(c.base+(uint64_t{2}<<40)+i);
    for(size_t i=0;i<Queries;i+=3) d.query[i]=d.batch[i%c.n];
    if(c.history) { for(size_t i=1;i<Queries;i+=3) d.query[i]=Hash(c.base+i%c.history); }
    else { for(size_t i=1;i<Queries;i+=3) d.query[i]=d.batch[(i*17)%c.n]; }
    return d;
}
uint64_t Digest(const std::vector<uint64_t>& values) {
    uint64_t result=14695981039346656037ULL;
    for(uint64_t value:values) result=(result^value)*1099511628211ULL;
    return result;
}
template<class F> void Prefill(F& filter,const Case& c) {
    std::array<uint64_t,Block> h;
    for(size_t begin=0;begin<c.history;begin+=Block) {
        const size_t len=std::min(Block,c.history-begin);
        for(size_t j=0;j<len;++j) h[j]=Hash(c.base+begin+j);
        filter.Insert(static_cast<uint32_t>(len),h.data());
    }
}
void Guards(const uint32_t* out,size_t n) {
    for(size_t i=0;i<16;++i) Need(out[i]==Guard && out[n+16+i]==Guard,"output guard changed");
}
template<class F> void Validate(const F& filter,const Case& c,const Data& d,
    const std::vector<uint32_t>& expected,std::vector<uint32_t>& out) {
    Need(filter.SizeInBytes()==c.bytes,"actual allocation changed");
    std::array<uint64_t,Block> h; std::array<uint32_t,Block+32> answers;
    for(size_t begin=0;begin<c.history;begin+=Block) {
        const size_t len=std::min(Block,c.history-begin);
        for(size_t j=0;j<len;++j) h[j]=Hash(c.base+begin+j);
        answers.fill(Guard);
        Need(filter.Lookup(static_cast<uint32_t>(len),h.data(),answers.data()+16)==len,"old output count");
        Guards(answers.data(),len);
        for(size_t j=0;j<len;++j) Need(answers[j+16]==1,"old key absent");
    }
    for(size_t begin=0;begin<c.n;begin+=Block) {
        const size_t len=std::min(Block,c.n-begin); answers.fill(Guard);
        Need(filter.Lookup(static_cast<uint32_t>(len),d.batch.data()+begin,answers.data()+16)==len,"new output count");
        Guards(answers.data(),len);
        for(size_t j=0;j<len;++j) Need(answers[j+16]==1,"new key absent");
    }
    for(bool parallel : {false,true}) {
        std::fill(out.begin(),out.end(),Guard);
        if(parallel) Affinity(c.cpus);
        const auto written=parallel ? filter.LookupParallel(Queries,d.query.data(),out.data()+16,c.requested)
                                    : filter.Lookup(Queries,d.query.data(),out.data()+16);
        Affinity({c.cpus.front()}); Need(written==Queries,"mixed output count"); Guards(out.data(),Queries);
        Need(std::equal(expected.begin(),expected.end(),out.begin()+16),"full mixed answers differ");
    }
}
struct Stats { size_t effective=0,workers=0,scratch=0; };
template<bool After,class F> Stats Observe(const F& f,const Case& c,bool serial) {
    Need(f.SizeInBytes()==c.bytes,"actual allocation changed");
    const size_t e=After && c.n<=65536 && c.bytes<=262144 ? 1 : c.requested;
    const size_t w=e; // Every fixed case exceeds the native fallback/count bounds.
    const size_t scratch=w==1 ? 0 : c.n*8+w*((w+7)/8)*64+(w+1)*8;
    Need(f.BuildWorkers(c.n,c.requested)==w &&
         f.BuildScratchBytes(c.n,c.requested)==scratch,"effective worker/scratch accounting changed");
    return serial ? Stats{1,1,0} : Stats{e,w,scratch};
}
struct Samples { Stats stats; std::array<std::vector<double>,2> ns,setup_ns; };
template<bool Range,bool After> void Trial(const Case& c,const Data& d,const std::vector<uint32_t>& expected,
    std::vector<uint32_t>& out,bool serial,bool allocate,Samples& samples) {
    Affinity({c.cpus.front()});
    if(!allocate) {
        auto filter=Make<Range,After>(c);
        samples.stats=Observe<After>(filter,c,serial);
        const auto setup_begin=Clock::now(); Prefill(filter,c); const auto setup_end=Clock::now();
        if(!serial) Affinity(c.cpus);
        const auto begin=Clock::now();
        if(serial) filter.Insert(static_cast<uint32_t>(c.n),d.batch.data());
        else filter.InsertParallel(static_cast<uint32_t>(c.n),d.batch.data(),c.requested);
        const auto end=Clock::now();
        Affinity({c.cpus.front()}); samples.ns[0].push_back(Ns(begin,end));
        samples.setup_ns[0].push_back(c.history ? Ns(setup_begin,setup_end) : 0);
        Validate(filter,c,d,expected,out);
    } else {
        Need(c.history==0,"populated allocation+build is unavailable");
        if(!serial) Affinity(c.cpus);
        const auto begin=Clock::now();
        auto filter=Make<Range,After>(c);
        if(serial) filter.Insert(static_cast<uint32_t>(c.n),d.batch.data());
        else filter.InsertParallel(static_cast<uint32_t>(c.n),d.batch.data(),c.requested);
        const auto end=Clock::now();
        Affinity({c.cpus.front()}); samples.ns[1].push_back(Ns(begin,end)); samples.setup_ns[1].push_back(0);
        samples.stats=Observe<After>(filter,c,serial); Validate(filter,c,d,expected,out);
    } // Destruction precedes the next arm; it is outside every clock.
}
void Array(const std::vector<double>& values) {
    std::cout<<'['; for(size_t i=0;i<values.size();++i) { if(i)std::cout<<','; std::cout<<values[i]; } std::cout<<']';
}
template<bool Range> void Run(const Case& c,bool corrupt) {
    const auto d=Workload(c); const auto batch_before=Digest(d.batch),query_before=Digest(d.query);
    std::vector<uint32_t> expected(Queries),out(Queries+32,Guard); std::array<Samples,3> samples;
    std::vector<std::string> executed;
    Affinity({c.cpus.front()});
    { auto oracle=Make<Range,false>(c); Need(oracle.SizeInBytes()==c.bytes,"oracle allocation changed");
      Prefill(oracle,c); oracle.Insert(static_cast<uint32_t>(c.n),d.batch.data());
      Need(oracle.Lookup(Queries,d.query.data(),expected.data())==Queries,"oracle output count");
      Validate(oracle,c,d,expected,out); }
    for(uint32_t x:expected) Need(x<=1,"oracle output not Boolean");
    if(corrupt) expected[0]^=1;
    for(size_t repeat=0;repeat<4;++repeat) {
        const bool allocation_first=repeat==1 || repeat==2;
        for(unsigned phase=0;phase<(c.history?1u:2u);++phase) {
            const bool allocate=!c.history && (phase==0 ? allocation_first : !allocation_first);
            for(unsigned arm:Schedule[repeat]) {
                if(arm==2) Trial<Range,true>(c,d,expected,out,false,allocate,samples[arm]);
                else Trial<Range,false>(c,d,expected,out,arm==0,allocate,samples[arm]);
                executed.push_back(std::to_string(repeat)+":"+(allocate?"allocate_insert":"insert")+":"+Arms[arm]);
            }
        }
    }
    Need(Digest(d.batch)==batch_before && Digest(d.query)==query_before,"input mutated");
    uint64_t checksum=14695981039346656037ULL; size_t positives=0;
    for(uint32_t x:expected) {checksum=(checksum^x)*1099511628211ULL;positives+=x;}
    std::cout<<std::setprecision(17)<<"{\"language\":\"cpp\",\"family\":\""<<(Range?"Split64Range":"Split64")
      <<"\",\"scenario\":"<<c.id<<",\"bytes\":"<<c.bytes<<",\"batch_n\":"<<c.n<<",\"requested\":"<<c.requested
      <<",\"history_n\":"<<c.history<<",\"hotspot\":"<<(c.hotspot?"true":"false")<<",\"seed\":"<<c.seed
      <<",\"input_base\":"<<c.base<<",\"query_n\":"<<Queries<<",\"checksum\":"<<checksum<<",\"positives\":"<<positives
      <<",\"batch_checksum\":"<<batch_before<<",\"query_checksum\":"<<query_before
      <<",\"repeats\":4,\"phase_order\":\"serial_pair_abba4\",\"scheduler\":\"caller_worker0\",\"time_unit\":\"absolute_ns\",\"cpus\":[";
    for(size_t i=0;i<c.cpus.size();++i) {if(i)std::cout<<',';std::cout<<c.cpus[i];}
    std::cout<<"],\"executed_order\":[";
    for(size_t i=0;i<executed.size();++i) {if(i)std::cout<<',';std::cout<<'"'<<executed[i]<<'"';}
    std::cout<<"],\"arms\":{";
    for(size_t arm=0;arm<3;++arm) {
        if(arm)std::cout<<','; const auto& s=samples[arm];
        std::cout<<'"'<<Arms[arm]<<"\":{\"effective\":"<<s.stats.effective<<",\"workers\":"<<s.stats.workers
          <<",\"scratch_bytes\":"<<s.stats.scratch<<",\"spawned_per_pass\":"<<(s.stats.workers-1)
          <<",\"insert_ns\":"; Array(s.ns[0]);std::cout<<",\"allocate_insert_ns\":";Array(s.ns[1]);
        std::cout<<",\"insert_prefill_setup_ns\":";Array(s.setup_ns[0]); std::cout<<'}';
    }
    std::cout<<"}}\n";
}
} // namespace
int main(int argc,char** argv) { try {
    Need(argc==7,"FAMILY SCENARIO REQUESTED SEED CPUS MODE required");
    const std::string family=argv[1],mode=argv[6];
    Need(family=="Split64" || family=="Split64Range","unknown family");
    auto number=[&](int i) {const std::string s=argv[i];Need(!s.empty()&&s.find_first_not_of("0123456789")==std::string::npos,"unsigned integer required");return std::stoull(s);};
    const auto scenario=number(2),request=number(3),seed=number(4);
    Need(scenario<6 && (request==4 || request==8) && (seed==74381 || seed==164321),"unregistered workload");
    Need(mode=="--measure" || mode=="--check-bad-output","unknown mode");
    auto cpus=external_parallel::ParseCpus(argv[5],request); Need(cpus.front()==2 || cpus.front()==3,"primary CPU must be2 or3");
    const auto c=GetCase(family=="Split64Range",scenario,request,seed,std::move(cpus));
    if(family=="Split64Range")Run<true>(c,mode=="--check-bad-output");else Run<false>(c,mode=="--check-bad-output");
} catch(const std::exception& error) {std::cerr<<error.what()<<'\n';return 1;} }
