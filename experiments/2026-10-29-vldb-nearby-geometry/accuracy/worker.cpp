// Accuracy-only public PImpl caller. Frozen upstream algorithms are untouched.
#include "../../../benchmarks/vldb-raw32-stage3/legacy-adapters.hpp"
#include "../../../benchmarks/vldb-raw32-stage3/common.hpp"
#include "../../../benchmarks/vldb-raw32-stage3/budget.hpp"
#include "../nearby_geometry.hpp"
#include <type_traits>

namespace nearby_accuracy {
using namespace raw32_stage3;
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
            vldb_nearby::Check(*selected);
            return *selected;
        } else return vldb_stage2::Plan(bytes,sizeof(Word)*W);
    }
    static size_t Bits(size_t n,uint32_t cap) {
        Filter::Configure();
        return Plan(n,cap).constructor_bits;
    }
public:
    PublicFilter(size_t n,uint32_t cap):filter_(Bits(n,cap)) {
        const auto g=Plan(n,cap);
        filter_.CheckConfiguration();
        geometry_.budget=g.budget_bytes;geometry_.bytes=filter_.backing_bytes();
        geometry_.logical=filter_.logical_bytes();
        Need(geometry_.bytes==g.backing_bytes && geometry_.logical==g.logical_bytes,
             "public actual allocation differs from fixed plan");
        geometry_.unit=g.block_bytes;geometry_.units=g.block_count;
        geometry_.argument=g.constructor_bits;geometry_.probes=8;
        geometry_.kind=Nearby?"original_blocked_bloom_nearby_odd":"original_blocked_bloom";
        geometry_.address=vldb_stage2::AddressName(g.address);
        geometry_.surface="artifact_pimpl";geometry_.metadata=filter_.Metadata();
        const auto& m=geometry_.metadata;
        for(const auto& token:{std::string("\"size\":")+std::to_string(g.logical_bytes)+",",
             std::string("\"word_size\":")+std::to_string(sizeof(Word))+",",
             std::string("\"k\":8,"),std::string("\"w\":")+std::to_string(W)+",",
             std::string("\"s\":")+std::to_string(W)+",",
             std::string("\"u\":")+std::to_string(U)+",",
             std::string("\"addr\":\"")+geometry_.address+"\""})
            Need(m.find(token)!=std::string::npos,"actual public metadata mismatch");
    }
    Geometry Info() const { return geometry_; }
    void Insert(uint32_t n,const uint32_t* raw) { filter_.Insert(n,raw); }
    bool Single(uint32_t key) const { return filter_.Contains(key); }
    void Prepare(Mode mode) {
        const size_t n=mode==Mode::PublicSingle?0:mode==Mode::DenseBatch1?1:4096;
        std::vector<uint32_t> replacement(n);
        Need(replacement.capacity()==n,"allocator scratch capacity differs from contract");
        positions_.swap(replacement);
    }
    void Dense(uint32_t n,const uint32_t* raw,uint32_t* out) const {
        filter_.Dense(n,raw,out,positions_.data());
    }
    size_t QueryScratchBytes() const { return positions_.capacity()*sizeof(uint32_t); }
    size_t BuildHashScratchBytes() const { return 0; }
    size_t FilterBuildScratchBytes() const { return 0; }
};

template<class Word,unsigned W,unsigned U>
int RunPolicy(const Args& args,bool nearby) {
    if(nearby) {
        const auto selected=vldb_nearby::Plan(exact_budget::Bytes(args.n(),args.bpk),sizeof(Word)*W);
        if(!selected) {
            Row row;Add(row,"status",std::string("unsupported"));Add(row,"filter",args.name);
            Add(row,"policy",std::string("nearby_odd"));Add(row,"keys",args.n());
            Add(row,"requested_bpk",args.bpk);Add(row,"budget_bytes",exact_budget::Bytes(args.n(),args.bpk));
            Print(row);return 0;
        }
        return Run<PublicFilter<Word,W,U,true>>("legacy",args);
    }
    return Run<PublicFilter<Word,W,U,false>>("legacy",args);
}
} // namespace nearby_accuracy

int main(int argc,char** argv) try {
    using namespace nearby_accuracy;
    Need(argc==6 || argc==11,"accuracy worker requires a final original|nearby_odd policy");
    const std::string action=argv[1],policy=argv[argc-1];
    // No timer action is reachable, including through a positive repeat count.
    Need(action=="--plan" || action=="--check" || action=="--check-bad-output",
         "accuracy-only worker rejects timing actions");
    Need(policy=="original" || policy=="nearby_odd","unknown geometry policy");
    const Args args=Parse(argc-1,argv);
    Need(policy=="original" || args.bpk==12 || args.bpk==24,"nearby only at12/24 caps");
    const bool nearby=policy=="nearby_odd";
    if(args.name=="sector32-u1/artifact_pimpl")return RunPolicy<uint32_t,8,1>(args,nearby);
    if(args.name=="sector64-u1/artifact_pimpl")return RunPolicy<uint64_t,8,1>(args,nearby);
    if(args.name=="register64-u0/artifact_pimpl")return RunPolicy<uint64_t,1,0>(args,nearby);
    throw std::invalid_argument("unknown fixed primary PImpl configuration");
} catch(const std::exception& e) { std::cerr<<e.what()<<'\n';return 2; }
