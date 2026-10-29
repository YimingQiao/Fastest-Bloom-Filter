// Correctness-only raw caller proof. No clock, no FPR estimate or throughput.
#include "adapters.hpp"
#include "snapshot/reference-k12/four_sector_range12.h"

namespace nearby_raw32 {
inline std::vector<uint32_t> FixtureInput(){
    std::vector<uint32_t> input(1031);
    for(size_t i=0;i<input.size();++i)input[i]=uint32_t(i*UINT64_C(2654435761)+731);
    input[0]=0;input[1]=UINT32_MAX;input[2]=UINT32_C(0x80000000);input[3]=input[1];return input;
}
inline std::vector<uint32_t> FixtureQuery(const std::vector<uint32_t>& input){
    std::vector<uint32_t> query(8193);
    for(size_t i=0;i<query.size();++i)query[i]=uint32_t(i*UINT64_C(2246822519)+100000);
    for(size_t i=1;i<query.size();i+=2)query[i]=input[i%input.size()];return query;
}
template<class F>std::vector<uint32_t> CheckAnswers(F& filter,const std::vector<uint32_t>& input,
                                                 const std::vector<uint32_t>& query){
    const auto before=Digest(input.data(),input.size()),before_q=Digest(query.data(),query.size());
    for(auto key:input)Need(filter.Single(key),"fixture false negative");
    std::vector<uint32_t> expected(query.size());
    for(size_t i=0;i<query.size();++i)expected[i]=filter.Single(query[i])?1u:0u;
    for(unsigned value=0;value<3;++value){
        const auto mode=static_cast<Mode>(value);filter.Prepare(mode);GuardedOutput out(query.size());
        vldb_stage2::Query(filter,mode,query.size(),query.data(),out.data());out.Check(expected.data());
        const auto unit=filter.Info().origin=="external"?4u:8u;
        Need(filter.QueryScratchBytes()==BatchCapacity(mode)*unit,"fixture physical scratch mismatch");
    }
    filter.Prepare(Mode::DenseBatch4096);
    for(size_t offset=0;offset<8;++offset){
        for(size_t n=0;n<=131;++n){GuardedOutput out(n);filter.Dense(n,query.data()+offset,out.data());out.Check(expected.data()+offset);}
        for(size_t n:{4095,4096,4097,4127}){GuardedOutput out(n);vldb_stage2::Query(filter,Mode::DenseBatch4096,n,query.data()+offset,out.data());out.Check(expected.data()+offset);}
    }
    Need(before==Digest(input.data(),input.size()) && before_q==Digest(query.data(),query.size()),"fixture input mutated");
    return expected;
}
template<class F,class=void>struct HasBitmap:std::false_type{};
template<class F>struct HasBitmap<F,std::void_t<decltype(std::declval<F&>().BitmapData())>>:std::true_type{};
struct BitmapPayload {
    template<class F>int Apply(const Args& args)const{
        if constexpr(!HasBitmap<F>::value)throw std::invalid_argument("only public PImpl fixtures have payload mode");
        else {
            F filter(args.n(),args.bpk);Need(filter.Info().origin=="external","payload requires public PImpl");
            const auto input=FixtureInput(),query=FixtureQuery(input);filter.Insert(input.size(),input.data());
            const auto expected=CheckAnswers(filter,input,query);const auto g=filter.Info();
            const std::vector<unsigned char> saved(static_cast<const unsigned char*>(filter.BitmapData()),
                                                  static_cast<const unsigned char*>(filter.BitmapData())+g.bytes);
            filter.Insert(input.size(),input.data());Need(std::memcmp(saved.data(),filter.BitmapData(),g.bytes)==0,"duplicate insertion changed bitmap");
            std::cout.write(reinterpret_cast<const char*>(filter.BitmapData()),g.bytes);
            for(uint32_t value:expected)for(unsigned j=0;j<4;++j)std::cout.put(char(value>>(j*8)));
            Need(bool(std::cout),"fixture payload write failed");return 0;
        }
    }
};
inline uint64_t ReferenceHash(uint32_t key){
    uint64_t x=key;x^=x>>32;x*=UINT64_C(0xd6e8feb86659fd93);x^=x>>32;x*=UINT64_C(0xd6e8feb86659fd93);x^=x>>32;return x;
}
inline uint64_t ByteDigest(const void* data,size_t bytes){
    const auto* p=static_cast<const unsigned char*>(data);uint64_t h=UINT64_C(14695981039346656037);
    for(size_t i=0;i<bytes;++i)h=(h^p[i])*UINT64_C(1099511628211);return h;
}
template<class Raw,class Ref>int NativeOracle(const Args& args){
    Raw filter(args.n(),args.bpk);const auto input=FixtureInput(),query=FixtureQuery(input);
    std::vector<uint64_t> hashes;for(auto key:input){const auto h=ReferenceHash(key);Need(h==bloom_filters::MurmurHash64(uint64_t(key)),"common raw32 zero extension/hash mismatch");hashes.push_back(h);}
    Ref reference(bloom_filters::RangeBytes{exact_budget::Bytes(args.n(),args.bpk)});
    for(size_t i=0;i<hashes.size();++i)reference.Insert(1,hashes.data()+i);
    filter.Insert(input.size(),input.data());const auto g=filter.Info();
    Need(g.bytes==reference.SizeInBytes(),"reference backing mismatch");
    Need(std::memcmp(filter.BitmapData(),reference.Data(),g.bytes)==0,"full reference bitmap mismatch");
    const auto answers=CheckAnswers(filter,input,query);
    for(size_t i=0;i<query.size();++i)Need(answers[i]==uint32_t(reference.ContainsHash(ReferenceHash(query[i]))),"full original public answer mismatch");
    filter.Insert(input.size(),input.data());Need(std::memcmp(filter.BitmapData(),reference.Data(),g.bytes)==0,"duplicate raw build changed bitmap");
    Row row;Add(row,"filter",args.name);Add(row,"keys",args.n());Add(row,"cap",args.bpk);Add(row,"actual_bytes",g.bytes);
    Add(row,"fixture_inserted",input.size());Add(row,"fixture_queries",query.size());Add(row,"full_bitmap_equal",1);
    Add(row,"full_outputs_equal",1);Add(row,"result_checksum",Digest(answers.data(),answers.size()));
    Add(row,"bitmap_checksum",ByteDigest(filter.BitmapData(),g.bytes));
    Add(row,"filter_build_scratch_bytes",filter.FilterBuildScratchBytes());
    Add(row,"full_n_build_hash_scratch_bytes",filter.BuildHashScratchBytes());
    Add(row,"fixture_build_hash_payload_bytes",input.size()*sizeof(uint64_t));
    Print(row);return 0;
}
}
int main(int argc,char** argv)try{
    using namespace nearby_raw32;
    Need(argc==5,"check --public-bitmap|--native-oracle NAME NPOWER CAP");
    const std::string mode=argv[1];Args args;args.name=argv[2];const auto power=Integer(argv[3]),cap=Integer(argv[4]);
    Need((power==16||power==25)&&(cap==12||cap==24),"fixed fixture geometry");args.power=power;args.bpk=cap;
    if(mode=="--public-bitmap"){Need(power==16,"bounded public bitmap fixture uses n16 only");return Dispatch(args,BitmapPayload{});}
    Need(mode=="--native-oracle","unknown correctness mode");
    if(args.name=="Split64RangeBloomFilter")return NativeOracle<RawRange,bloom_filters::Split64RangeBloomFilter>(args);
    if(args.name=="FourSectorRange12Experiment")return NativeOracle<RawK12,bloom_filters::FourSectorRange12>(args);
    throw std::invalid_argument("unknown native oracle type");
}catch(const std::exception& error){std::cerr<<error.what()<<'\n';return 2;}
