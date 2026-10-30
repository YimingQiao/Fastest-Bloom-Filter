#pragma once
#include "legacy-adapters.hpp"
#include "raw_hash.hpp"
#include "../2026-10-29-vldb-nearby-geometry/nearby_geometry.hpp"
#include "snapshot/range/split64_range_bloom.h"
#include "snapshot/k12/four_sector_range12.h"
#include "snapshot/visible_raw_hash.hpp"
#include <optional>

namespace nearby_raw32 {
using namespace raw32_stage3;

// Same public PImpl mapping and methods as the frozen accuracy caller. U2/U4
// add public captured-closure shapes, not new hashes or private implementations.
template<class Word,unsigned W,unsigned U,bool Nearby>
class PublicFilter {
    using Public=std::conditional_t<sizeof(Word)==4,dtl::bbf_32,dtl::bbf_64>;
    using Filter=vldb_external::ArtifactPublic<Public,W,W,8,U>;
    Filter filter_;
    Geometry geometry_;
    mutable std::vector<uint32_t> positions_;
    static vldb_stage2::Geometry Plan(size_t n,uint32_t cap) {
        const auto bytes=exact_budget::Bytes(n,cap);
        if constexpr(Nearby) {
            const auto selected=vldb_nearby::Plan(bytes,sizeof(Word)*W);
            Need(bool(selected),"unsupported fixed nearby geometry");
            vldb_nearby::Check(*selected);return *selected;
        } else return vldb_stage2::Plan(bytes,sizeof(Word)*W);
    }
    static size_t Bits(size_t n,uint32_t cap) { Filter::Configure();return Plan(n,cap).constructor_bits; }
public:
    PublicFilter(size_t n,uint32_t cap):filter_(Bits(n,cap)) {
        const auto g=Plan(n,cap);filter_.CheckConfiguration();
        geometry_.budget=g.budget_bytes;geometry_.bytes=filter_.backing_bytes();geometry_.logical=filter_.logical_bytes();
        Need(geometry_.bytes==g.backing_bytes && geometry_.logical==g.logical_bytes,"actual public geometry changed");
        geometry_.unit=g.block_bytes;geometry_.units=g.block_count;geometry_.argument=g.constructor_bits;geometry_.probes=8;
        geometry_.kind=Nearby?"original_blocked_bloom_nearby_odd":"original_blocked_bloom";
        geometry_.address=vldb_stage2::AddressName(g.address);geometry_.surface="artifact_pimpl";geometry_.metadata=filter_.Metadata();
        for(const auto& token:{std::string("\"size\":")+std::to_string(g.logical_bytes)+",",
             std::string("\"word_size\":")+std::to_string(sizeof(Word))+",",std::string("\"k\":8,"),
             std::string("\"w\":")+std::to_string(W)+",",std::string("\"s\":")+std::to_string(W)+",",
             std::string("\"u\":")+std::to_string(U)+",",std::string("\"addr\":\"")+geometry_.address+"\""})
            Need(geometry_.metadata.find(token)!=std::string::npos,"actual public metadata mismatch");
    }
    Geometry Info()const{return geometry_;}
    void Insert(uint32_t n,const uint32_t* raw){filter_.Insert(n,raw);}
    bool Single(uint32_t key)const{return filter_.Contains(key);}
    void Prepare(Mode mode){ExactScratch(positions_,BatchCapacity(mode));}
    void Dense(uint32_t n,const uint32_t* raw,uint32_t* out)const{filter_.Dense(n,raw,out,positions_.data());}
    size_t QueryScratchBytes()const{return positions_.capacity()*sizeof(uint32_t);}
    size_t BuildHashScratchBytes()const{return 0;}
    size_t FilterBuildScratchBytes()const{return 0;}
    // Fixture-only, never called from a measured query.
    const void* BitmapData()const{return filter_.data();}
};

struct RangePublic : bloom_filters::Split64RangeBloomFilter {
    using bloom_filters::Split64RangeBloomFilter::Split64RangeBloomFilter;
    bool ScalarContains(uint64_t hash)const{return ContainsHash(hash);}
};
struct K12Public : nearby_k12::FourSectorRange12 {
    using nearby_k12::FourSectorRange12::FourSectorRange12;
    bool ScalarContains(uint64_t hash)const{return ContainsHash(hash);}
};
template<class F,bool K12>struct ExactNativePolicy {
    static Geometry Plan(size_t n,uint32_t cap){
        Geometry g;g.budget=exact_budget::Bytes(n,cap);g.bytes=g.logical=exact_budget::FloorUnits(g.budget,64);
        g.unit=64;g.units=g.bytes/64;g.argument=g.budget;g.probes=K12?12:8;
        g.kind=K12?"four_sector_range12":"native_split64_range_lines";
        g.address=K12?"top24_multiply":"high32_multiply";
        g.origin=K12?"project_experiment":"optional_native_range";
        g.surface="public_contains_hash_and_lookup";return g;
    }
    static F Make(size_t n,uint32_t cap){
        if constexpr(K12)return F(nearby_k12::RangeBytes{Plan(n,cap).argument});
        else return F(bloom_filters::RangeBytes{Plan(n,cap).argument});
    }
};
using RawRange=VisibleRawHash<RangePublic,ExactNativePolicy<RangePublic,false>>;
using RawK12=VisibleRawHash<K12Public,ExactNativePolicy<K12Public,true>>;

inline const std::vector<std::string>& Names(){
    static const std::vector<std::string> names=[] {
        std::vector<std::string> out;
        for(const char* config:{"sector32-u1","sector32-u2","sector32-u4","sector64-u1","sector64-u2","sector64-u4","register64-u0"})
            for(const char* policy:{"original","nearby_odd"})out.push_back(std::string(config)+"/artifact_pimpl/"+policy);
        for(const char* name:{"FastPatternBF","FourSectorBloomFilter","Split64BloomFilter","ByteSplitBloomFilter",
                             "Split64RangeBloomFilter","FourSectorRange12Experiment"})out.push_back(name);
        return out;
    }();return names;
}

// Factory dispatch executes a caller supplied typed operation. Construction and
// PImpl lifetime remain wholly inside that operation, one row per process.
template<class Word,unsigned W,unsigned U,class Operation>
int Policy(const Args& args,bool nearby,Operation&& operation){
    if(nearby){
        if(!vldb_nearby::Plan(exact_budget::Bytes(args.n(),args.bpk),sizeof(Word)*W)){
            Row row;Add(row,"status",std::string("unsupported"));Add(row,"filter",args.name);Add(row,"policy",std::string("nearby_odd"));
            Add(row,"keys",args.n());Add(row,"requested_bpk",args.bpk);Add(row,"budget_bytes",exact_budget::Bytes(args.n(),args.bpk));Print(row);return 0;
        }
        return operation.template Apply<PublicFilter<Word,W,U,true>>(args);
    }
    return operation.template Apply<PublicFilter<Word,W,U,false>>(args);
}
template<class Operation>int Dispatch(const Args& args,Operation&& operation){
    Need(std::find(Names().begin(),Names().end(),args.name)!=Names().end(),"unknown fixed API");
    Need(args.bpk==12 || args.bpk==24,"only caps12/24 are proposed");
#define NATIVE(NAME,TYPE) if(args.name==NAME)return operation.template Apply<TYPE>(args)
    NATIVE("FastPatternBF",RawFastPattern);NATIVE("FourSectorBloomFilter",RawFourSector);
    NATIVE("Split64BloomFilter",RawSplit64);NATIVE("ByteSplitBloomFilter",RawByteSplit);
    NATIVE("Split64RangeBloomFilter",RawRange);NATIVE("FourSectorRange12Experiment",RawK12);
#undef NATIVE
    const auto slash=args.name.find('/');const auto config=args.name.substr(0,slash);
    const bool nearby=args.name.substr(args.name.find_last_of('/')+1)=="nearby_odd";
#define PUBLIC(NAME,WORD,W,U) if(config==NAME)return Policy<WORD,W,U>(args,nearby,std::forward<Operation>(operation))
    PUBLIC("sector32-u1",uint32_t,8,1);PUBLIC("sector32-u2",uint32_t,8,2);PUBLIC("sector32-u4",uint32_t,8,4);
    PUBLIC("sector64-u1",uint64_t,8,1);PUBLIC("sector64-u2",uint64_t,8,2);PUBLIC("sector64-u4",uint64_t,8,4);
    PUBLIC("register64-u0",uint64_t,1,0);
#undef PUBLIC
    throw std::runtime_error("registered API lacks dispatcher");
}
} // namespace nearby_raw32
