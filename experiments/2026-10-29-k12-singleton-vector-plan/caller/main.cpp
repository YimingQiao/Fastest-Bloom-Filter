#include "control.h"
#include "candidate.h"
#include "query_helpers.hpp"
#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

using namespace bloom_filters;
using Clock = std::chrono::steady_clock;
static volatile uint64_t sink;
static constexpr uint32_t guard_word = 0xfeed1234;
struct SplitMix64 {
    uint64_t state;
    uint64_t operator()() {
        uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
        z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
        z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
        return z ^ (z >> 31);
    }
};
template <class T> void Shuffle(std::vector<T>& v, SplitMix64& rng) {
    for (size_t i = v.size(); i > 1; --i) std::swap(v[i-1], v[rng() % i]);
}
template <class T> uint64_t Digest(const T* values, size_t n) {
    uint64_t value = 14695981039346656037ULL;
    for (size_t i = 0; i < n; ++i) value = (value ^ values[i]) * 1099511628211ULL;
    return value;
}
struct Case {
    unsigned power, hit, query_power, batch, repeats, order;
    uint64_t seed;
    bool measure, inject;
};
struct Input {
    std::vector<uint64_t> inserted_raw, query_raw, inserted, query;
    uint64_t key_base, inserted_digest, query_digest, inserted_hash_digest, query_hash_digest;
};
struct Output {
    std::vector<uint32_t> words;
    size_t n;
    explicit Output(size_t count) : words(count + 32, guard_word), n(count) {}
    uint32_t* data() { return words.data() + 16; }
    void Poison() { std::fill(data(), data() + n, 2); }
    void Check(const std::vector<uint32_t>& expected) {
        if (!std::equal(expected.begin(), expected.end(), data()))
            throw std::runtime_error("full output mismatch");
        for (size_t i = 0; i < 16; ++i)
            if (words[i] != guard_word || words[n + 16 + i] != guard_word)
                throw std::runtime_error("output guard overwritten");
        sink = Digest(data(), n);
    }
};
template <class BF> void Run(const char* name, const Case& c, const Input& d) {
    const size_t n = d.inserted.size(), q = d.query.size();
    BF filter(n, 24); // One canonical bitmap. Construction is never timed.
    if (filter.SizeInBytes() != n * 3) throw std::runtime_error("wrong actual bytes");
    filter.Insert(static_cast<uint32_t>(n), d.inserted.data());
    Output out(std::max<size_t>(q, c.batch));
    std::vector<uint64_t> scratch(c.batch);
    for (size_t i = 0; i < n; i += c.batch) {
        const size_t count = std::min<size_t>(c.batch, n-i);
        lookup_kernel(filter, count, d.inserted.data()+i, out.data());
        for (size_t j = 0; j < count; ++j)
            if (out.data()[j] != 1 || !filter.ContainsHash(d.inserted[i+j]))
                throw std::runtime_error("inserted false negative");
    }
    std::vector<uint32_t> expected(q);
    filter.LookupScalar(static_cast<uint32_t>(q), d.query.data(), expected.data());
    uint64_t present=0, absent=0, false_positive=0;
    for (size_t i=0; i<q; ++i) {
        if (expected[i] > 1) throw std::runtime_error("non-dense scalar output");
        if (d.query_raw[i]>=d.key_base && d.query_raw[i]<d.key_base+n) {
            ++present; if (!expected[i]) throw std::runtime_error("mixed false negative");
        } else { ++absent; false_positive += expected[i]; }
    }
    if (c.inject) expected.back() ^= 1;
    // Warm all measured contracts and validate dense outputs before timing.
    for (size_t i=0; i<q; i+=c.batch)
        lookup_kernel(filter, std::min<size_t>(c.batch,q-i), d.query.data()+i, out.data()+i);
    out.Check(expected);
    for (size_t i=0; i<q; i+=c.batch) {
        const size_t count=std::min<size_t>(c.batch,q-i);
        HashVector(count,d.query_raw.data()+i,scratch.data());
        lookup_kernel(filter,count,scratch.data(),out.data()+i);
    }
    out.Check(expected);
    if (c.batch==1) {
        inline_single_kernel<false,BF,uint64_t>(filter,q,d.query.data(),out.data()); out.Check(expected);
        inline_single_kernel<true,BF,uint64_t>(filter,q,d.query_raw.data(),out.data()); out.Check(expected);
    }
    const unsigned four[4][4]={{0,1,3,2},{1,2,0,3},{2,3,1,0},{3,0,2,1}};
    const unsigned two[4][2]={{0,1},{1,0},{1,0},{0,1}};
    const unsigned modes=c.batch==1 ? 4 : 2;
    std::array<std::vector<double>,4> samples;
    std::vector<unsigned> phase_order;
    for (unsigned repeat=0; repeat<c.repeats; ++repeat) {
        for (unsigned position=0; position<modes; ++position) {
            const unsigned mode=modes==4 ? four[repeat%4][position] : two[repeat%4][position];
            phase_order.push_back(mode);
            out.Poison();
            const auto start=Clock::now();
            switch (mode) {
            case 0:
                for (size_t i=0; i<q; i+=c.batch)
                    lookup_kernel(filter,std::min<size_t>(c.batch,q-i),d.query.data()+i,out.data()+i);
                break;
            case 1:
                for (size_t i=0; i<q; i+=c.batch) {
                    const size_t count=std::min<size_t>(c.batch,q-i);
                    HashVector(count,d.query_raw.data()+i,scratch.data());
                    lookup_kernel(filter,count,scratch.data(),out.data()+i);
                }
                break;
            case 2:
                inline_single_kernel<false,BF,uint64_t>(filter,q,d.query.data(),out.data());
                break;
            case 3:
                inline_single_kernel<true,BF,uint64_t>(filter,q,d.query_raw.data(),out.data());
                break;
            }
            const auto end=Clock::now();
            const double value=std::chrono::duration<double,std::nano>(end-start).count()/q;
            if (!std::isfinite(value) || value<=0) throw std::runtime_error("invalid timing");
            samples[mode].push_back(value);
            out.Check(expected);
        }
    }
    if (Digest(d.inserted_raw.data(),n)!=d.inserted_digest || Digest(d.query_raw.data(),q)!=d.query_digest ||
        Digest(d.inserted.data(),n)!=d.inserted_hash_digest || Digest(d.query.data(),q)!=d.query_hash_digest)
        throw std::runtime_error("input mutated");
    const char* mode_names[]={"generic_pure","generic_staged_common_hash","visible_public_pure","visible_public_fused_common_hash"};
    std::cout << std::setprecision(17) << "{\"filter\":\"" << name << "\",\"keys\":" << n
              << ",\"queries\":" << q << ",\"actual_bytes\":" << filter.SizeInBytes()
              << ",\"hit\":" << c.hit << ",\"batch\":" << c.batch << ",\"repeats\":" << c.repeats
              << ",\"seed\":" << c.seed << ",\"order\":" << c.order << ",\"measure\":" << (c.measure?"true":"false")
              << ",\"key_base\":" << d.key_base << ",\"inserted_digest\":" << d.inserted_digest
              << ",\"query_digest\":" << d.query_digest << ",\"bitmap_digest\":" << Digest(filter.Data(),filter.SizeInBytes()/4)
              << ",\"inserted_hash_digest\":" << d.inserted_hash_digest << ",\"query_hash_digest\":" << d.query_hash_digest
              << ",\"result_digest\":" << Digest(expected.data(),q) << ",\"present\":" << present
              << ",\"absent\":" << absent << ",\"false_positives\":" << false_positive << ",\"phase_order\":[";
    for (size_t i=0;i<phase_order.size();++i) { if(i)std::cout<<',';std::cout<<phase_order[i]; }
    std::cout << "],\"samples\":{";
    for (unsigned mode=0;mode<4;++mode) {
        if(mode)std::cout<<',';std::cout<<'\"'<<mode_names[mode]<<"\":[";
        for(size_t i=0;i<samples[mode].size();++i){if(i)std::cout<<',';std::cout<<samples[mode][i];}
        std::cout<<']';
    }
    std::cout << "}}\n" << std::flush;
}

int main(int argc,char** argv) {
    try {
        if(argc!=9) throw std::invalid_argument("expected mode power hit query_power batch repeats seed order");
        auto Number=[&](int i){std::string s=argv[i];if(s.empty()||s.find_first_not_of("0123456789")!=std::string::npos)throw std::invalid_argument("unsigned integer required");const auto v=std::stoull(s);if(v>UINT32_MAX)throw std::invalid_argument("integer too large");return static_cast<unsigned>(v);};
        const std::string mode=argv[1];
        if(mode!="--check"&&mode!="--fault"&&mode!="--measure")throw std::invalid_argument("unknown mode");
        Case c{Number(2),Number(3),Number(4),Number(5),Number(6),Number(8),Number(7),mode=="--measure",mode=="--fault"};
        if(c.order>1 || (c.hit!=0&&c.hit!=50&&c.hit!=100) ||
           (c.batch!=1&&c.batch!=3&&c.batch!=31&&c.batch!=4096))throw std::invalid_argument("unsupported grid");
        if(c.measure) {
            if((c.power!=16&&c.power!=25)||c.query_power!=22||c.repeats!=8||(c.seed!=16057&&c.seed!=32029))throw std::invalid_argument("formal grid mismatch");
        } else if((c.power!=8&&c.power!=16)||c.query_power!=12||c.repeats!=4||c.seed!=74381)throw std::invalid_argument("proof grid mismatch");
        const size_t n=size_t{1}<<c.power,q=size_t{1}<<c.query_power;
        Input d;d.inserted_raw.resize(n);d.query_raw.resize(q);d.inserted.resize(n);d.query.resize(q);
        SplitMix64 rng{c.seed};d.key_base=rng()%((uint64_t{1}<<32)-n-q);
        std::iota(d.inserted_raw.begin(),d.inserted_raw.end(),d.key_base);Shuffle(d.inserted_raw,rng);
        for(size_t i=0;i<q;++i)d.query_raw[i]=d.key_base+((i%100<c.hit)?rng()%n:n+i);
        Shuffle(d.query_raw,rng);
        HashVector(n,d.inserted_raw.data(),d.inserted.data());HashVector(q,d.query_raw.data(),d.query.data());
        d.inserted_digest=Digest(d.inserted_raw.data(),n);d.query_digest=Digest(d.query_raw.data(),q);
        d.inserted_hash_digest=Digest(d.inserted.data(),n);d.query_hash_digest=Digest(d.query.data(),q);
        std::vector<unsigned> jobs{0,1};Shuffle(jobs,rng);
        jobs=c.order?std::vector<unsigned>{1,0}:std::vector<unsigned>{0,1};
        for(unsigned job:jobs) {
            if(job==0)Run<FourSectorRange12BloomFilter>("Control",c,d);
            else Run<FourSectorRange12SingletonVectorExperiment>("Candidate",c,d);
        }
    } catch(const std::exception& e) {std::cerr<<e.what()<<'\n';return 1;}
}
