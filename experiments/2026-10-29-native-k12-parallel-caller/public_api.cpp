// Actual native public T1/T8 APIs. No common-executor or external build ranking.
#include "parallel_layout_bloom.h"
#include "parallel_split64_range_bloom.h"
#include "parallel_four_sector_range12_bloom.h"
#include "budget.hpp"
#include "placement.hpp"
#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <sstream>
#include <type_traits>

using namespace bloom_filters;
using Clock=std::chrono::steady_clock;
static volatile uint64_t sink;
static void Need(bool ok,const char* message){if(!ok)throw std::runtime_error(message);}
static double Nanos(Clock::time_point a,Clock::time_point b){return std::chrono::duration<double,std::nano>(b-a).count();}
struct SplitMix64 {
    uint64_t state;
    uint64_t operator()(){uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}
};
template<class T>static void Shuffle(std::vector<T>& values,SplitMix64& rng){for(size_t n=values.size();n>1;--n)std::swap(values[n-1],values[rng()%n]);}
template<class T>static uint64_t Digest(const T* values,size_t n){uint64_t h=14695981039346656037ULL;for(size_t i=0;i<n;++i)h=(h^values[i])*1099511628211ULL;return h;}
struct Workload {
    size_t n,q;uint64_t seed,base;
    std::vector<uint64_t> raw_insert,raw_query;
    std::vector<uint64_t,AlignedAllocator<uint64_t,4096>> inserted,query;
    Workload(size_t n_,size_t q_,uint64_t seed_):n(n_),q(q_),seed(seed_),raw_insert(n),raw_query(q),inserted(n),query(q){
        SplitMix64 rng{seed};base=rng()%((uint64_t{1}<<32)-n-q);std::iota(raw_insert.begin(),raw_insert.end(),base);Shuffle(raw_insert,rng);
        for(size_t i=0;i<q;++i)raw_query[i]=base+((i%100<50)?rng()%n:n+i);Shuffle(raw_query,rng);
        HashVector(n,raw_insert.data(),inserted.data());HashVector(q,raw_query.data(),query.data());
    }
};
struct Samples {
    std::vector<double> values;
    void Add(Clock::time_point a,Clock::time_point b,size_t count){values.push_back(Nanos(a,b)/count);}
    void Print() const {
        Need(!values.empty(),"empty sample vector");auto sorted=values;std::sort(sorted.begin(),sorted.end());const size_t n=sorted.size();
        const double median=n%2?sorted[n/2]:(sorted[n/2-1]+sorted[n/2])/2;
        std::cout<<','<<median<<','<<sorted.front()<<','<<sorted.back()<<',';
        for(size_t i=0;i<n;++i){if(i)std::cout<<'|';std::cout<<values[i];}
    }
};
template<class Serial>struct PublicTraits;
template<>struct PublicTraits<Split64BloomFilter>{using Parallel=ParallelSplit64BloomFilter;static uint32_t Argument(size_t n,uint32_t bpk){return exact_budget::NativeArgument(n,exact_budget::Bytes(n,bpk));}};
template<>struct PublicTraits<Split64RangeBloomFilter>{using Parallel=ParallelSplit64RangeBloomFilter;static uint32_t Argument(size_t,uint32_t bpk){return bpk;}};
template<>struct PublicTraits<FourSectorRange12BloomFilter>{using Parallel=ParallelFourSectorRange12BloomFilter;static uint32_t Argument(size_t,uint32_t bpk){return bpk;}};
template<class T,class=void>struct HasData:std::false_type{};
template<class T>struct HasData<T,std::void_t<decltype(std::declval<const T&>().Data())>>:std::true_type{};
static void AllowCpus(const std::vector<int>& cpus){cpu_set_t set;CPU_ZERO(&set);for(int cpu:cpus)CPU_SET(cpu,&set);const int rc=pthread_setaffinity_np(pthread_self(),sizeof(set),&set);if(rc)throw std::runtime_error("cannot enable native API CPU mask");}

template<class Serial>
void Run(const char* name,size_t n,size_t q,uint32_t bpk,uint64_t seed,unsigned repeats,const std::vector<int>& cpus){
    using Parallel=typename PublicTraits<Serial>::Parallel;
    const uint32_t argument=PublicTraits<Serial>::Argument(n,bpk);const size_t budget=exact_budget::Bytes(n,bpk);
    Workload work(n,q,seed);
    const uint64_t input_digest=Digest(work.inserted.data(),n),query_digest=Digest(work.query.data(),q);
    const uint64_t raw_input_digest=Digest(work.raw_insert.data(),n),raw_query_digest=Digest(work.raw_query.data(),q);
    std::vector<uint32_t> expected(q);
    std::vector<unsigned char> bitmap;
    size_t actual_bytes=0,present=0,absent=0,false_positives=0;
    uint64_t result_checksum=0;
    // The untimed serial reference is destroyed before any measured bitmap exists.
    {
        Serial reference(n,argument);actual_bytes=reference.SizeInBytes();Need(actual_bytes<=budget,"native backing exceeds cap");reference.Insert(n,work.inserted.data());
        reference.Lookup(q,work.query.data(),expected.data());
        if constexpr(HasData<Serial>::value){const auto* bytes=reinterpret_cast<const unsigned char*>(reference.Data());bitmap.assign(bytes,bytes+actual_bytes);}
        for(size_t i=0;i<q;++i){Need(expected[i]<=1,"serial non-dense answer");if(work.raw_query[i]>=work.base&&work.raw_query[i]<work.base+n){++present;Need(expected[i]==1,"serial false negative");}else{++absent;false_positives+=expected[i];}}
        Need(present==q/100*50+std::min<size_t>(q%100,50),"wrong exact hit count");result_checksum=Digest(expected.data(),q);
    }
    constexpr uint32_t guard=0xfeed0123;
    std::vector<uint32_t,AlignedAllocator<uint32_t,4096>> storage(q+32,guard);
    uint32_t* output=storage.data()+16;
    auto validate_output=[&]{
        for(size_t i=0;i<16;++i)Need(storage[i]==guard&&storage[q+16+i]==guard,"public output guard changed");
        Need(std::equal(expected.begin(),expected.end(),output),"complete public threaded output mismatch");
        const uint64_t checksum=Digest(output,q);Need(checksum==result_checksum,"public output checksum mismatch");sink=checksum;
    };
    auto validate_filter=[&](const Parallel& filter,size_t requested){
        Need(filter.SizeInBytes()==actual_bytes,"public allocation changed");
        if constexpr(HasData<Parallel>::value){static_assert(HasData<Serial>::value,"public bitmap needs serial reference access");Need(bitmap.size()==actual_bytes&&std::memcmp(filter.Data(),bitmap.data(),actual_bytes)==0,"complete public bitmap differs from serial reference");}
        std::array<uint32_t,4098> hits{};hits.front()=hits.back()=guard;
        for(size_t i=0;i<n;i+=4096){const size_t length=std::min<size_t>(4096,n-i);filter.Lookup(length,work.inserted.data()+i,hits.data()+1);for(size_t j=0;j<length;++j)Need(hits[j+1]==1,"public construction inserted false negative");Need(hits.front()==guard&&hits.back()==guard,"inserted-key check output guard");}
        filter.LookupParallel(q,work.query.data(),output,requested);validate_output();
    };
    std::array<Samples,2> insert,allocated_insert,lookup;
    std::array<size_t,2> build_workers{},scratch_bytes{},query_workers{};
    std::ostringstream phase;
    for(unsigned repeat=0;repeat<repeats;++repeat){
        if(repeat)phase<<';';
        for(unsigned position=0;position<2;++position){
            const unsigned slot=(repeat+position)&1;const size_t requested=slot?8:1;
            if(position)phase<<'|';phase<<requested;
            const auto start=Clock::now();
            Parallel fresh(n,argument);
            const auto ready=Clock::now();
            fresh.InsertParallel(n,work.inserted.data(),requested);
            const auto done=Clock::now();
            insert[slot].Add(ready,done,n);allocated_insert[slot].Add(start,done,n);
            build_workers[slot]=fresh.BuildWorkers(n,requested);scratch_bytes[slot]=fresh.BuildScratchBytes(n,requested);
            Need(build_workers[slot]==requested,"formal/tiny public construction worker count changed");
            validate_filter(fresh,requested);
            // Destruction occurs after the timed operation and validation.
        }
    }
    {
        Parallel filter(n,argument);filter.InsertParallel(n,work.inserted.data(),8);validate_filter(filter,8);
        for(size_t requested:{size_t{1},size_t{8}}){filter.LookupParallel(q,work.query.data(),output,requested);validate_output();}
        for(unsigned repeat=0;repeat<repeats;++repeat)for(unsigned position=0;position<2;++position){
            const unsigned slot=(repeat+position)&1;const size_t requested=slot?8:1;
            const auto start=Clock::now();filter.LookupParallel(q,work.query.data(),output,requested);const auto done=Clock::now();
            lookup[slot].Add(start,done,q);validate_output();query_workers[slot]=parallel_detail::Workers(q,requested);
            Need(query_workers[slot]==requested,"public query effective workers changed");
        }
    }
    Need(input_digest==Digest(work.inserted.data(),n)&&query_digest==Digest(work.query.data(),q)&&raw_input_digest==Digest(work.raw_insert.data(),n)&&raw_query_digest==Digest(work.raw_query.data(),q),"public caller input mutation");
    const size_t caller_bytes=(work.raw_insert.capacity()+work.raw_query.capacity()+work.inserted.capacity()+work.query.capacity())*sizeof(uint64_t)+(expected.capacity()+storage.capacity())*sizeof(uint32_t)+bitmap.capacity();
    std::cout<<std::setprecision(17)<<"cpp,"<<name<<','<<n<<','<<q<<','<<bpk<<','<<actual_bytes<<','<<8.0*actual_bytes/n<<','<<seed<<','<<repeats<<','<<argument<<','<<present<<','<<absent<<','<<false_positives<<','<<result_checksum<<','<<input_digest<<','<<query_digest<<','<<raw_input_digest<<','<<raw_query_digest<<','<<build_workers[0]<<','<<build_workers[1]<<','<<query_workers[0]<<','<<query_workers[1]<<','<<scratch_bytes[0]<<','<<scratch_bytes[1]<<','<<HasData<Parallel>::value<<','<<bitmap.capacity()<<','<<expected.capacity()*sizeof(uint32_t)<<','<<caller_bytes<<','<<phase.str()<<",prehashed_native_public_api,0";
    insert[0].Print();allocated_insert[0].Print();insert[1].Print();allocated_insert[1].Print();lookup[0].Print();lookup[1].Print();std::cout<<'\n';
}
int main(int argc,char** argv){try{
    if(argc!=8)throw std::invalid_argument("expected key_power bpk query_power paired_repeats seed one_filter cpu_list");
    auto number=[&](unsigned i){const std::string s=argv[i];if(s.empty()||s.find_first_not_of("0123456789")!=std::string::npos)throw std::invalid_argument("unsigned integer required");return std::stoull(s);};
    const uint64_t power=number(1),bpk=number(2),qp=number(3),repeats=number(4),seed=number(5);const std::string name=argv[6];
    Need(power>=15&&power<=25&&qp>=15&&qp<=22&&bpk>=1&&bpk<=32&&repeats>=2&&repeats<=32&&repeats%2==0,"unsupported public API workload");
    Need(name=="Split64BloomFilter"||name=="Split64RangeBloomFilter"||name=="FourSectorRange12BloomFilter","unknown public API filter");
    const auto cpus=external_parallel::ParseCpus(argv[7],8);AllowCpus(cpus);
    std::cout<<"language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,seed,repeats,native_constructor_argument,present_queries,absent_queries,false_positives,result_checksum,inserted_hash_checksum,query_hash_checksum,raw_insert_checksum,raw_query_checksum,build_workers_t1,build_workers_t8,query_workers_t1,query_workers_t8,build_scratch_bytes_t1,build_scratch_bytes_t8,public_bitmap_compared,validation_bitmap_bytes,validation_expected_output_bytes,caller_buffer_bytes,paired_phase_order,measurement_mode,new_calibration_samples";
    for(const char* name:{"insert_t1","allocate_insert_t1","insert_t8","allocate_insert_t8","lookup_t1","lookup_t8"})for(const char* field:{"ns","min_ns","max_ns","trials_ns"})std::cout<<','<<name<<'_'<<field;std::cout<<'\n';
    const size_t n=size_t{1}<<power,q=size_t{1}<<qp;
    if(name=="Split64BloomFilter")Run<Split64BloomFilter>(name.c_str(),n,q,bpk,seed,repeats,cpus);
    else if(name=="Split64RangeBloomFilter")Run<Split64RangeBloomFilter>(name.c_str(),n,q,bpk,seed,repeats,cpus);
    else Run<FourSectorRange12BloomFilter>(name.c_str(),n,q,bpk,seed,repeats,cpus);
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 1;}}
