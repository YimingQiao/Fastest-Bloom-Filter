#include <dtl/filter/bbf_32.hpp>
#include <dtl/filter/bbf_64.hpp>
#include <iostream>
template<class T> void check(unsigned u,unsigned w,unsigned s){T::force_unroll_factor(u);T f(32768,8,w,s);std::cout<<"requested="<<u<<" "<<f.name()<<"\n";}
int main(){check<dtl::bbf_32>(1,8,8);check<dtl::bbf_64>(1,8,8);check<dtl::bbf_64>(0,1,1);check<dtl::bbf_32>(2,8,8);check<dtl::bbf_32>(4,8,8);check<dtl::bbf_64>(2,8,8);check<dtl::bbf_64>(4,8,8);}
