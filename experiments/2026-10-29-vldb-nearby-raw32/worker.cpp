#include "adapters.hpp"
namespace nearby_raw32 {
struct TimedOrChecked {
    template<class F>int Apply(const Args& args)const{return Run<F>("nearby_legacy",args);}
};
}
int main(int argc,char** argv)try{
    using namespace nearby_raw32;
    if(argc==2 && std::string(argv[1])=="--names"){for(const auto& name:Names())std::cout<<name<<'\n';return 0;}
    const auto args=Parse(argc,argv);
    return Dispatch(args,TimedOrChecked{});
}catch(const std::exception& error){std::cerr<<error.what()<<'\n';return 2;}
