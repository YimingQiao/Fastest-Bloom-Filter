#include "focused.hpp"
#include "adapters.hpp"
#include "geometry.hpp"
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
    unsigned power, hit, query_power, batch, repeats, order, calibration_power;
    uint64_t seed;
    bool measure, inject, allocation_only;
};
struct Point {
    const char *name, *id, *owner;
    size_t keys;
    uint32_t bpk;
    size_t backing, logical, unit_bytes, units;
    int probes;
    size_t constructor_argument;
    const char *kind, *probe_policy;
    uint32_t native_bpk;
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


template<class BF, class=void> struct HasData : std::false_type {};
template<class BF> struct HasData<BF,std::void_t<decltype(std::declval<const BF&>().Data())>> : std::true_type {};
template<class BF, class=void> struct HasScalarLookup : std::false_type {};
template<class BF> struct HasScalarLookup<BF,std::void_t<decltype(std::declval<const BF&>().LookupScalar(
    uint32_t{}, std::declval<const uint64_t*>(), std::declval<uint32_t*>()))>> : std::true_type {};
template<class BF, class=void> struct HasProbeCount : std::false_type {};
template<class BF> struct HasProbeCount<BF,std::void_t<decltype(std::declval<const BF&>().ProbeCount())>> : std::true_type {};

template<class BF> void GeometryCheck(const BF& filter, const Point& p) {
    const auto g = exact_budget::Traits<BF>::Plan(p.keys,p.bpk);
    if (filter.SizeInBytes()!=p.backing || g.allocated_bytes!=p.backing ||
        g.logical_bytes!=p.logical || g.unit_bytes!=p.unit_bytes || g.units!=p.units || g.probes!=p.probes ||
        g.constructor_argument!=p.constructor_argument || g.native_bpk!=p.native_bpk ||
        std::string(g.kind)!=p.kind || std::string(g.probe_policy)!=p.probe_policy)
        throw std::runtime_error("exact geometry mismatch");
    if constexpr(HasProbeCount<BF>::value)
        if (filter.ProbeCount()!=p.probes) throw std::runtime_error("public probe count mismatch");
}
template<class BF> void BitmapField(const BF& filter) {
    if constexpr(HasData<BF>::value)
        std::cout << Digest(static_cast<const uint8_t*>(static_cast<const void*>(filter.Data())),filter.SizeInBytes());
    else std::cout << "null";
}
void PointFields(const Point& p) {
    std::cout << "\"point_id\":\"" << p.id << "\",\"filter\":\"" << p.name
              << "\",\"owner\":\"" << p.owner << "\",\"keys\":" << p.keys
              << ",\"requested_bpk\":" << p.bpk << ",\"actual_bytes\":" << p.backing
              << ",\"budget_bytes\":" << p.keys*p.bpk/8 << ",\"logical_bytes\":" << p.logical
              << ",\"unit_bytes\":" << p.unit_bytes << ",\"unit_count\":" << p.units
              << ",\"effective_probes\":" << p.probes << ",\"constructor_argument\":" << p.constructor_argument
              << ",\"native_constructor_bpk\":" << p.native_bpk << ",\"geometry_kind\":\"" << p.kind
              << "\",\"probe_policy\":\"" << p.probe_policy << '"';
}
template<class BF> void Allocation(const Point& p) {
    const auto filter=exact_budget::Traits<BF>::Make(p.keys,p.bpk);
    GeometryCheck(filter,p);
    std::cout << '{';PointFields(p);std::cout << ",\"bitmap_available\":" << (HasData<BF>::value?"true":"false") << ",\"allocation_only\":true}\n" << std::flush;
}
template<class BF> void Run(const Point& p, const Case& c, const Input& d) {
    const size_t n=d.inserted.size(),q=d.query.size();
    auto filter=exact_budget::Traits<BF>::Make(n,p.bpk);
    GeometryCheck(filter,p);
    filter.Insert(static_cast<uint32_t>(n),d.inserted.data());
    uint64_t initial_bitmap = 0;
    if constexpr(HasData<BF>::value) initial_bitmap = Digest(static_cast<const uint8_t*>(static_cast<const void*>(filter.Data())),filter.SizeInBytes());
    Output out(std::max<size_t>(q,c.batch));
    std::vector<uint64_t> scratch(c.batch);
    for(size_t i=0;i<n;i+=c.batch) {
        const size_t count=std::min<size_t>(c.batch,n-i);
        // Poison only the written prefix: total inserted validation is O(n),
        // including batch1. Full q-word poison belongs to whole-query phases.
        std::fill_n(out.data(),count,uint32_t{2});
        lookup_kernel(filter,count,d.inserted.data()+i,out.data());
        for(size_t j=0;j<count;++j)
            if(out.data()[j]!=1 || !visible_single<BF,uint64_t>(filter,d.inserted[i+j]))
                throw std::runtime_error("inserted false negative");
    }
    std::vector<uint32_t> expected(q);
    if constexpr(HasScalarLookup<BF>::value)
        filter.LookupScalar(static_cast<uint32_t>(q),d.query.data(),expected.data());
    else for(size_t i=0;i<q;++i) expected[i]=visible_single<BF,uint64_t>(filter,d.query[i]);
    uint64_t present=0,absent=0,false_positive=0;
    for(size_t i=0;i<q;++i) {
        if(expected[i]>1) throw std::runtime_error("non-dense scalar output");
        if(d.query_raw[i]>=d.key_base && d.query_raw[i]<d.key_base+n) {
            ++present;if(!expected[i])throw std::runtime_error("mixed false negative");
        } else {++absent;false_positive+=expected[i];}
    }
    uint64_t calibration_count=0,calibration_fp=0,calibration_digest=14695981039346656037ULL;
    if(c.calibration_power) {
        calibration_count=uint64_t{1}<<c.calibration_power;
        std::array<uint64_t,4096> raw{},hashes{};
        for(uint64_t begin=0;begin<calibration_count;begin+=raw.size()) {
            const size_t count=std::min<uint64_t>(raw.size(),calibration_count-begin);
            for(size_t i=0;i<count;++i)raw[i]=d.key_base+n+q+begin+i;
            HashVector(count,raw.data(),hashes.data());
            for(size_t i=0;i<count;++i) {
                const uint32_t value=visible_single<BF,uint64_t>(filter,hashes[i]);
                if(value>1)throw std::runtime_error("non-dense calibration output");
                calibration_fp+=value;
                calibration_digest=(calibration_digest^value)*1099511628211ULL;
            }
        }
    }
    if(c.inject)expected.back()^=1;
    // Complete validation and all scratch/bitmap allocation stay outside clocks.
    out.Poison();
    for(size_t i=0;i<q;i+=c.batch)
        lookup_kernel(filter,std::min<size_t>(c.batch,q-i),d.query.data()+i,out.data()+i);
    out.Check(expected);out.Poison();
    for(size_t i=0;i<q;i+=c.batch) {
        const size_t count=std::min<size_t>(c.batch,q-i);
        HashVector(count,d.query_raw.data()+i,scratch.data());
        lookup_kernel(filter,count,scratch.data(),out.data()+i);
    }
    out.Check(expected);
    if(c.batch==1) {
        out.Poison();inline_single_kernel<false,BF,uint64_t>(filter,q,d.query.data(),out.data());out.Check(expected);
        out.Poison();inline_single_kernel<true,BF,uint64_t>(filter,q,d.query_raw.data(),out.data());out.Check(expected);
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

    if(Digest(d.inserted_raw.data(),n)!=d.inserted_digest || Digest(d.query_raw.data(),q)!=d.query_digest ||
       Digest(d.inserted.data(),n)!=d.inserted_hash_digest || Digest(d.query.data(),q)!=d.query_hash_digest)
        throw std::runtime_error("input mutated");
    if constexpr(HasData<BF>::value)
        if(initial_bitmap != Digest(static_cast<const uint8_t*>(static_cast<const void*>(filter.Data())),filter.SizeInBytes()))
            throw std::runtime_error("query mutated bitmap");
    const char* mode_names[]={"generic_pure","generic_staged_common_hash","visible_public_pure","visible_public_fused_common_hash"};
    std::cout<<std::setprecision(17)<<'{';PointFields(p);
    std::cout<<",\"queries\":"<<q<<",\"hit\":"<<c.hit<<",\"batch\":"<<c.batch<<",\"repeats\":"<<c.repeats
             <<",\"seed\":"<<c.seed<<",\"reverse_jobs\":"<<(c.order?"true":"false")
             <<",\"measure\":"<<(c.measure?"true":"false")<<",\"key_base\":"<<d.key_base
             <<",\"inserted_digest\":"<<d.inserted_digest<<",\"query_digest\":"<<d.query_digest
             <<",\"inserted_hash_digest\":"<<d.inserted_hash_digest<<",\"query_hash_digest\":"<<d.query_hash_digest
             <<",\"result_digest\":"<<Digest(expected.data(),q)<<",\"present\":"<<present
             <<",\"absent\":"<<absent<<",\"false_positives\":"<<false_positive
             <<",\"calibration_negatives\":"<<calibration_count<<",\"calibration_fp\":"<<calibration_fp
             <<",\"calibration_digest\":";
    if(calibration_count)std::cout<<calibration_digest;else std::cout<<"null";
    std::cout<<",\"bitmap_available\":"<<(HasData<BF>::value?"true":"false");
    std::cout<<",\"bitmap_digest\":";BitmapField(filter);
    std::cout<<",\"query_scratch_bytes\":"<<scratch.size()*sizeof(uint64_t)<<",\"phase_order\":[";
    for(size_t i=0;i<phase_order.size();++i){if(i)std::cout<<',';std::cout<<phase_order[i];}
    std::cout<<"],\"samples\":{";
    for(unsigned mode=0;mode<4;++mode){
        if(mode)std::cout<<',';std::cout<<'\"'<<mode_names[mode]<<"\":[";
        for(size_t i=0;i<samples[mode].size();++i){if(i)std::cout<<',';std::cout<<samples[mode][i];}
        std::cout<<']';
    }
    std::cout<<"}}\n"<<std::flush;
}

struct Job {Point point;void(*run)(const Point&,const Case&,const Input&);void(*allocation)(const Point&);};
std::vector<Job> Jobs(size_t n,bool proof) {
    std::vector<Job> jobs;
#define ADD(TYPE,NAME,ID,OWNER,N,BPK,BACKING,LOGICAL,UNIT_BYTES,UNITS,PROBES,ARG,KIND,POLICY,NATIVE_BPK) \
    if(n==(N))jobs.push_back({{NAME,ID,OWNER,N,BPK,BACKING,LOGICAL,UNIT_BYTES,UNITS,PROBES,ARG,KIND,POLICY,NATIVE_BPK},&Run<TYPE>,&Allocation<TYPE>});
#include "points.inc"
    if(proof) {
#include "proof-point.inc"
    }
#undef ADD
    return jobs;
}
int main(int argc,char** argv) {
    try {
        if(argc==2 && std::string(argv[1])=="--prefetch-check")return prefetch64_proof::Run();
        if(argc!=10)throw std::invalid_argument("expected mode power hit query_power batch repeats seed reverse calibration_power");
        auto Number=[&](int i){std::string s=argv[i];if(s.empty()||s.find_first_not_of("0123456789")!=std::string::npos)throw std::invalid_argument("unsigned integer required");const auto v=std::stoull(s);if(v>UINT32_MAX)throw std::invalid_argument("integer too large");return static_cast<unsigned>(v);};
        const std::string mode=argv[1];
        if(mode!="--measure"&&mode!="--check"&&mode!="--fault"&&mode!="--geometry")throw std::invalid_argument("unknown mode");
        Case c{Number(2),Number(3),Number(4),Number(5),Number(6),Number(8),Number(9),Number(7),mode=="--measure",mode=="--fault",mode=="--geometry"};
        if(c.order>1 || c.hit!=50 || (c.batch!=1&&c.batch!=31&&c.batch!=4096))
            throw std::invalid_argument("unsupported grid");
        const bool primary=c.batch==1;
        if(c.measure) {
            if((c.power!=16&&c.power!=25)||c.query_power!=22||c.repeats!=8||
               (c.seed!=982451653&&c.seed!=961748941)||c.calibration_power!=(primary&&c.order==0?26u:0u))
                throw std::invalid_argument("formal grid mismatch");
        } else if(c.seed!=74381||c.query_power!=12||c.repeats!=4||
                  (c.allocation_only?(c.power!=16&&c.power!=25):c.power!=16)||
                  c.calibration_power!=(primary&&!c.allocation_only?10u:0u))
            throw std::invalid_argument("proof grid mismatch");
        const size_t n=size_t{1}<<c.power,q=size_t{1}<<c.query_power;
        auto jobs=Jobs(n,!c.measure&&!c.allocation_only);
        if(c.allocation_only){for(const auto&job:jobs)job.allocation(job.point);return 0;}
        Input d;d.inserted_raw.resize(n);d.query_raw.resize(q);d.inserted.resize(n);d.query.resize(q);
        SplitMix64 rng{c.seed};d.key_base=rng()%((uint64_t{1}<<32)-n-q);
        std::iota(d.inserted_raw.begin(),d.inserted_raw.end(),d.key_base);Shuffle(d.inserted_raw,rng);
        for(size_t i=0;i<q;++i)d.query_raw[i]=d.key_base+((i%100<c.hit)?rng()%n:n+i);
        Shuffle(d.query_raw,rng);
        HashVector(n,d.inserted_raw.data(),d.inserted.data());HashVector(q,d.query_raw.data(),d.query.data());
        d.inserted_digest=Digest(d.inserted_raw.data(),n);d.query_digest=Digest(d.query_raw.data(),q);
        d.inserted_hash_digest=Digest(d.inserted.data(),n);d.query_hash_digest=Digest(d.query.data(),q);
        Shuffle(jobs,rng);if(c.order)std::reverse(jobs.begin(),jobs.end());
        for(const auto&job:jobs)job.run(job.point,c,d);
    } catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 1;}
}
