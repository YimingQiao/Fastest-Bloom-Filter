#include "../../cpp/bindings.hpp"
#include <algorithm>
#include <array>
#include <iostream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>

namespace {
void Need(bool ok, const char* text) { if (!ok) throw std::runtime_error(text); }
constexpr uint32_t Guard = 0xfeed;
constexpr size_t Block = 4096, QueryCount = 32771;
constexpr uint64_t NewBase = uint64_t{1} << 40, NegativeBase = uint64_t{2} << 40;
uint64_t Hash(uint64_t index) {
    uint64_t z = 0x243f6a8885a308d3ULL + (index + 1) * 0x9e3779b97f4a7c15ULL;
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
struct Event { std::string method; size_t n, request; const uint64_t* input; uint32_t* output; };
struct Spy {
    size_t bytes; std::vector<Event>* events;
    Spy(size_t b, std::vector<Event>* e) : bytes(b), events(e) {}
    size_t SizeInBytes() const { return bytes; }
    size_t BuildWorkers(size_t n, size_t r) const { events->push_back({"workers",n,r,nullptr,nullptr}); return r+7; }
    size_t BuildScratchBytes(size_t n, size_t r) const { events->push_back({"scratch",n,r,nullptr,nullptr}); return n+r*11+bytes; }
    void Insert(uint32_t n, const uint64_t* h) { events->push_back({"insert",n,0,h,nullptr}); }
    void InsertParallel(uint32_t n, const uint64_t* h, size_t r) { events->push_back({"parallel_insert",n,r,h,nullptr}); }
    uint32_t Lookup(uint32_t n, const uint64_t* h, uint32_t* out) const { events->push_back({"lookup",n,0,h,out}); return n+17; }
    uint32_t LookupParallel(uint32_t n, const uint64_t* h, uint32_t* out, size_t r) const { events->push_back({"parallel_lookup",n,r,h,out}); return n+19; }
};
template<bool Enabled> size_t SpyCases() {
    std::vector<uint64_t> input(65537); std::vector<uint32_t> output(65537); size_t count=0;
    for(size_t n : {0u,1u,16383u,16384u,65535u,65536u,65537u})
        for(size_t bytes : {131072u,262144u,262208u,524288u,67108864u,100663296u})
            for(size_t request : {0u,1u,4u,8u}) {
                const bool small_batch = n != 65537, small_bitmap = bytes == 131072 || bytes == 262144;
                const size_t effective = Enabled && small_batch && small_bitmap ? 1 : request;
                std::vector<Event> events;
                native_build_policy::Filter<Spy,Enabled> filter(bytes,&events);
                Need(filter.SizeInBytes()==bytes && filter.EffectiveBuildRequest(n,request)==effective,"spy sizing/request");
                Need(filter.BuildWorkers(n,request)==effective+7,"spy worker result");
                Need(filter.BuildScratchBytes(n,request)==n+effective*11+bytes,"spy scratch result");
                filter.Insert(static_cast<uint32_t>(n),input.data());
                filter.InsertParallel(static_cast<uint32_t>(n),input.data(),request);
                Need(filter.Lookup(static_cast<uint32_t>(n),input.data(),output.data())==n+17,"spy serial return");
                Need(filter.LookupParallel(static_cast<uint32_t>(n),input.data(),output.data(),request)==n+19,"spy parallel return");
                Need(events.size()==6,"spy exact calls");
                const std::array<std::string,6> names={"workers","scratch","insert","parallel_insert","lookup","parallel_lookup"};
                const std::array<size_t,6> requests={effective,effective,0,effective,0,request};
                for(size_t i=0;i<6;++i) {
                    Need(events[i].method==names[i] && events[i].n==n && events[i].request==requests[i],"spy routing");
                    Need(events[i].input==(i>=2?input.data():nullptr),"spy exact input pointer");
                    Need(events[i].output==(i>=4?output.data():nullptr),"spy exact output pointer");
                }
                ++count;
            }
    return count;
}
struct Case { size_t id,bytes,n,requested,history; bool hotspot; };
Case GetCase(bool range, size_t id) {
    const size_t large=range?100663296:67108864;
    const std::array<Case,6> cases={{{0,262144,65536,1,0,false},{1,262144,65537,4,0,false},
        {2,262144,65536,4,131072,true},{3,range?262208u:524288u,65536,8,0,false},
        {4,large,65536,0,0,false},{5,large,65536,8,large/2,true}}};
    return cases.at(id);
}
template<bool Range,bool Enabled> using Filter=native_build_policy::Filter<
    std::conditional_t<Range,bloom_filters::ParallelSplit64RangeBloomFilter,bloom_filters::ParallelSplit64BloomFilter>,Enabled>;
template<bool Range,bool Enabled> Filter<Range,Enabled> Make(const Case& c) {
    if constexpr(Range) return Filter<Range,Enabled>(bloom_filters::RangeBytes{c.bytes});
    else return Filter<Range,Enabled>(c.bytes/2,8);
}
void CheckGuards(const uint32_t* out,size_t n) {
    for(size_t i=0;i<16;++i) Need(out[i]==Guard && out[n+16+i]==Guard,"output guard overwritten");
}
template<class F> void Prefill(F& filter,size_t count) {
    std::array<uint64_t,Block> hashes;
    for(size_t begin=0;begin<count;begin+=Block) {
        const size_t len=std::min(Block,count-begin);
        for(size_t j=0;j<len;++j) hashes[j]=Hash(begin+j);
        filter.Insert(static_cast<uint32_t>(len),hashes.data());
    }
}
template<class F> void CheckInserted(const F& filter,const Case& c,const std::vector<uint64_t>& batch) {
    std::array<uint64_t,Block> hashes; std::array<uint32_t,Block+32> out;
    for(size_t begin=0;begin<c.history;begin+=Block) {
        const size_t len=std::min(Block,c.history-begin);
        for(size_t j=0;j<len;++j) hashes[j]=Hash(begin+j);
        out.fill(Guard); filter.Lookup(static_cast<uint32_t>(len),hashes.data(),out.data()+16); CheckGuards(out.data(),len);
        for(size_t j=0;j<len;++j) Need(out[j+16]==1,"old inserted key missing");
    }
    for(size_t begin=0;begin<batch.size();begin+=Block) {
        const size_t len=std::min(Block,batch.size()-begin);
        out.fill(Guard); filter.Lookup(static_cast<uint32_t>(len),batch.data()+begin,out.data()+16); CheckGuards(out.data(),len);
        for(size_t j=0;j<len;++j) Need(out[j+16]==1,"new inserted key missing");
    }
}
size_t Workers(size_t n,size_t request,size_t bytes) {
    if(n<16384) return 1;
    return std::max<size_t>(1,std::min({request,n/4096,bytes/64,size_t{1024}}));
}
size_t Scratch(size_t n,size_t w) { return w==1?0:n*8+w*((w+7)/8)*64+(w+1)*8; }
struct Stats { size_t request,workers,scratch,auto_workers; };
template<bool Range,bool Enabled> Stats Variant(const Case& c,const std::vector<uint64_t>& batch,
    const std::vector<uint64_t>& query,std::vector<uint32_t>& expected,bool serial) {
    auto filter=Make<Range,Enabled>(c); Need(filter.SizeInBytes()==c.bytes,"wrong actual allocation");
    const size_t effective=Enabled && c.id<3 && c.n==65536 ? 1 : c.requested;
    Need(filter.EffectiveBuildRequest(c.n,c.requested)==effective,"wrong actual effective request");
    const size_t auto_workers=filter.BuildWorkers(c.n,0);
    const size_t workers=effective?Workers(c.n,effective,c.bytes):auto_workers, scratch=Scratch(c.n,workers);
    Need(filter.BuildWorkers(c.n,c.requested)==workers && filter.BuildScratchBytes(c.n,c.requested)==scratch,"wrong actual workers/scratch");
    Need(filter.BuildScratchBytes(c.n,0)==Scratch(c.n,auto_workers),"wrong actual automatic scratch");
    Prefill(filter,c.history);
    if(serial) filter.Insert(static_cast<uint32_t>(batch.size()),batch.data());
    else filter.InsertParallel(static_cast<uint32_t>(batch.size()),batch.data(),c.requested);
    CheckInserted(filter,c,batch);
    std::vector<uint32_t> out(query.size()+32,Guard);
    filter.Lookup(static_cast<uint32_t>(query.size()),query.data(),out.data()+16); CheckGuards(out.data(),query.size());
    if(serial) expected.assign(out.begin()+16,out.end()-16);
    else Need(std::equal(expected.begin(),expected.end(),out.begin()+16),"serial dense outputs differ");
    for(uint32_t value:expected) Need(value<=1,"not dense Boolean output");
    std::fill(out.begin(),out.end(),Guard);
    filter.LookupParallel(static_cast<uint32_t>(query.size()),query.data(),out.data()+16,c.requested);
    CheckGuards(out.data(),query.size()); Need(std::equal(expected.begin(),expected.end(),out.begin()+16),"parallel dense outputs differ");
    return {effective,workers,scratch,auto_workers}; // Native bitmap dies before the next variant allocates.
}
template<bool Range> void RealCases() {
    for(size_t id=0;id<6;++id) {
        const auto c=GetCase(Range,id); std::vector<uint64_t> batch(c.n),query(QueryCount);
        for(size_t i=0;i<c.n;++i) batch[i]=c.hotspot?Hash(NewBase+i)&0xffffffffULL:Hash(NewBase+i);
        for(size_t i=0;i<query.size();++i) query[i]=Hash(NegativeBase+i);
        for(size_t i=0;i<query.size();i+=3) query[i]=batch[i%c.n];
        if(c.history) { for(size_t i=1;i<query.size();i+=3) query[i]=Hash(i%c.history); }
        else { for(size_t i=1;i<query.size();i+=3) query[i]=batch[(i*17)%c.n]; }
        std::vector<uint32_t> expected;
        const auto reference=Variant<Range,false>(c,batch,query,expected,true);
        const auto control=Variant<Range,false>(c,batch,query,expected,false);
        const auto candidate=Variant<Range,true>(c,batch,query,expected,false);
        Need(control.auto_workers==reference.auto_workers,"original automatic scheduler drift");
        Need(candidate.auto_workers==((id==0||id==2)?1:reference.auto_workers),"automatic request incorrectly changed");
        uint64_t checksum=14695981039346656037ULL; size_t positives=0;
        for(uint32_t value:expected) {checksum=(checksum^value)*1099511628211ULL;positives+=value;}
        std::cout<<"{\"language\":\"cpp\",\"family\":\""<<(Range?"Split64Range":"Split64")<<"\",\"case\":"<<id
          <<",\"bytes\":"<<c.bytes<<",\"batch_n\":"<<c.n<<",\"requested\":"<<c.requested<<",\"history_n\":"<<c.history
          <<",\"hotspot\":"<<(c.hotspot?"true":"false")<<",\"query_n\":"<<query.size()<<",\"control_effective\":"<<control.request
          <<",\"candidate_effective\":"<<candidate.request<<",\"control_workers\":"<<control.workers<<",\"candidate_workers\":"<<candidate.workers
          <<",\"native_auto_workers\":"<<reference.auto_workers<<",\"candidate_auto_workers\":"<<candidate.auto_workers
          <<",\"control_scratch\":"<<control.scratch<<",\"candidate_scratch\":"<<candidate.scratch<<",\"checksum\":"<<checksum
          <<",\"positives\":"<<positives<<",\"checked_history_per_variant\":"<<c.history<<",\"checked_new_per_variant\":"<<c.n
          <<",\"variants\":3,\"full_mixed_checks_per_variant\":2,\"performance_run\":false}\n";
    }
}
}
int main(int argc,char** argv) { try {
    Need(argc==2,"one mode --spy or --real required"); const std::string mode=argv[1];
    if(mode=="--spy") {const size_t cases=SpyCases<false>()+SpyCases<true>();Need(cases==336,"wrong spy grid");
        std::cout<<"{\"language\":\"cpp\",\"spy_cases\":"<<cases<<",\"forwarded_calls\":"<<cases*6<<",\"performance_run\":false}\n";}
    else if(mode=="--real") {RealCases<false>();RealCases<true>();}
    else Need(false,"unknown mode");
} catch(const std::exception& error) {std::cerr<<error.what()<<'\n';return 1;} }
