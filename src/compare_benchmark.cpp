#include <algorithm>
#include <chrono>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <random>
#include <sstream>
#include <string>
#include <vector>
#include "cache_sectorized_BF_32bit.h"
#include "new_cache_sectorized_BF_32bit.h"
#include "register_blocked_BF_32bit.h"
#include "register_blocked_BF_32bit_Masks.h"
#include "register_blocked_BF_64bit.h"
#include "register_blocked_BF_64bit_Masks.h"
#include "register_blocked_BF_2x32bit.h"
#include "impala_blocked_BF_64bit.h"
#ifdef __AVX512F__
#include "impala_blocked_BF_64bit_avx512.h"
#endif

using namespace bloom_filters;
using Clock = std::chrono::steady_clock;
static volatile uint64_t sink;
static double ns(Clock::time_point a, Clock::time_point b) {
    return std::chrono::duration<double, std::nano>(b-a).count();
}
static double median(std::vector<double> v) {
    std::sort(v.begin(), v.end()); return v.size()%2 ? v[v.size()/2] : (v[v.size()/2-1]+v[v.size()/2])/2;
}
template<class BF> BF make_filter(size_t n, uint32_t bpk) {
    std::ostringstream ignored;
    struct Restore {
        std::streambuf *buffer;
        ~Restore() { std::cout.rdbuf(buffer); }
    } restore{std::cout.rdbuf(ignored.rdbuf())};
    return BF(n,bpk);
}
template<class BF, class Hash>
void run(const char *name, const std::vector<uint64_t>& raw_insert,
         const std::vector<uint64_t>& raw_query, uint32_t bpk, unsigned hit,
         size_t batch, unsigned repeats, uint64_t seed, uint64_t key_base) {
    const size_t n = raw_insert.size(), q = raw_query.size();
    std::vector<Hash> inserted(n), hashes(q), scratch(batch);
    std::vector<uint32_t> output(std::max(q,batch));
    HashVector(n, raw_insert.data(), inserted.data());
    HashVector(q, raw_query.data(), hashes.data());
    BF bf=make_filter<BF>(n,bpk);
    std::vector<double> insert_times, build_times;
    for (unsigned trial=0; trial<repeats; ++trial) {
        auto a=Clock::now();
        BF fresh=make_filter<BF>(n,bpk);
        auto ready=Clock::now();
        for (size_t i=0; i<n; i+=batch) fresh.Insert(std::min(batch,n-i),inserted.data()+i);
        auto b=Clock::now();
        insert_times.push_back(ns(ready,b)/n);
        build_times.push_back(ns(a,b)/n);
        fresh.Lookup(std::min(n,batch),inserted.data(),output.data());
        sink=std::accumulate(output.begin(),output.begin()+std::min(n,batch),uint64_t{0});
    }
    for (size_t i=0; i<n; i+=batch) bf.Insert(std::min(batch,n-i),inserted.data()+i);
    for (size_t i=0; i<n; i+=batch) {
        size_t len=std::min(batch,n-i);
        bf.Lookup(len,inserted.data()+i,output.data());
        for (size_t j=0;j<len;++j) if (output[j]!=1) throw std::runtime_error("false negative");
    }
    // Warm-up and validate output before measuring. Query arrays are disjoint for misses.
    for (size_t i=0;i<q;i+=batch) bf.Lookup(std::min(batch,q-i),hashes.data()+i,output.data()+i);
    uint64_t false_positives=0, absent=0, present=0;
    for(size_t i=0;i<q;++i) {
        if(output[i]>1) throw std::runtime_error("output must be 0 or 1");
        if(raw_query[i]>=key_base && raw_query[i]<key_base+n) {
            ++present;
            if(!output[i]) throw std::runtime_error("false negative in mixed workload");
        } else { ++absent; false_positives+=output[i]; }
    }
    std::vector<double> lookup, total;
    for (unsigned r=0;r<repeats;++r) {
        auto start=Clock::now();
        for (size_t i=0;i<q;i+=batch) bf.Lookup(std::min(batch,q-i),hashes.data()+i,output.data()+i);
        auto end=Clock::now();
        lookup.push_back(ns(start,end)/q);
        sink=std::accumulate(output.begin(),output.begin()+q,uint64_t{0});
        start=Clock::now();
        for (size_t i=0;i<q;i+=batch) {
            size_t len=std::min(batch,q-i);
            HashVector(len,raw_query.data()+i,scratch.data());
            bf.Lookup(len,scratch.data(),output.data()+i);
        }
        end=Clock::now();
        total.push_back(ns(start,end)/q);
        sink=std::accumulate(output.begin(),output.begin()+q,uint64_t{0});
    }
    std::cout<<name<<','<<n<<','<<q<<','<<bpk<<','<<bf.SizeInBytes()<<','
             <<8.0*bf.SizeInBytes()/n<<','<<sizeof(Hash)*8<<','<<hit<<','<<present<<','
             <<batch<<','<<repeats<<','<<seed<<','<<median(insert_times)<<','<<median(build_times)<<','
             <<median(lookup)<<','<<median(total)<<','<<absent<<','<<false_positives<<',';
    if(absent) std::cout<<double(false_positives)/absent;
    else std::cout<<"nan";
    std::cout<<','<<*std::min_element(lookup.begin(),lookup.end())<<','
             <<*std::max_element(lookup.begin(),lookup.end())<<'\n';
}
int main(int argc,char**argv) {
    try {
        if(argc>9) throw std::invalid_argument("too many arguments");
        auto number=[&](int i,uint64_t fallback) {
            if(argc<=i) return fallback;
            std::string str=argv[i];
            if(str.empty() || str.find_first_not_of("0123456789")!=std::string::npos)
                throw std::invalid_argument("arguments must be unsigned integers");
            uint64_t value=std::stoull(str);
            if(i!=7 && value>UINT32_MAX) throw std::invalid_argument("argument too large");
            return value;
        };
        unsigned power=number(1,16);
        uint32_t bpk=number(2,16);
        unsigned hit=number(3,0);
        unsigned qp=number(4,22);
        size_t batch=number(5,4096);
        unsigned repeats=number(6,5);
        uint64_t seed=number(7,42);
        if(power>26||power<5||qp>27||qp<12||!bpk||bpk>32||hit>100||!batch||batch>(1u<<qp)||!repeats)
            throw std::invalid_argument("unsupported benchmark arguments");
        size_t n=size_t{1}<<power,q=size_t{1}<<qp;
        if(n*bpk >= (size_t{1}<<31)) throw std::invalid_argument("legacy size overflow");
        // Permuted unique integers give disjoint hit/miss sets; hashing is separately timed.
        std::vector<uint64_t> ins(n),query(q);
        std::mt19937_64 rng(seed);
        const uint64_t key_base=rng()%((uint64_t{1}<<32)-n-q);
        std::iota(ins.begin(),ins.end(),key_base);
        std::shuffle(ins.begin(),ins.end(),rng);
        for(size_t i=0;i<q;++i) query[i]=key_base+((i%100<hit)?rng()%n:n+i);
        std::shuffle(query.begin(),query.end(),rng);
        std::cout<<"filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,false_positives,fpr,lookup_min_ns,lookup_max_ns\n";
        std::string selection=argc>8?argv[8]:"";
        std::vector<std::function<void()>> jobs;
#define ADD(T,H) if(selection.empty() || (","+selection+",").find("," #T ",")!=std::string::npos) jobs.emplace_back([&]{run<T,H>(#T,ins,query,bpk,hit,batch,repeats,seed,key_base);})
        ADD(RegisterBlockedBF32Bit,uint32_t);
        ADD(RegisterBlockedBF32BitMasks,uint32_t);
        ADD(RegisterBlockedBF64Bit,uint64_t);
        ADD(RegisterBlockedBF64BitMasks,uint64_t);
        ADD(RegisterBlockedBF2x32Bit,uint64_t);
        ADD(CacheSectorizedBF32Bit,uint64_t);
        ADD(NewCacheSectorizedBF32Bit,uint64_t);
        ADD(ImpalaBlockedBF64Bit,uint64_t);
#ifdef __AVX512F__
        ADD(ImpalaBlockedBF64BitAVX512,uint64_t);
#endif
        if(jobs.empty()) throw std::invalid_argument("no matching filters");
        std::shuffle(jobs.begin(),jobs.end(),rng);
        for(auto&job:jobs) job();
    } catch(const std::exception&e) { std::cerr<<e.what()<<'\n';return 1; }
}
