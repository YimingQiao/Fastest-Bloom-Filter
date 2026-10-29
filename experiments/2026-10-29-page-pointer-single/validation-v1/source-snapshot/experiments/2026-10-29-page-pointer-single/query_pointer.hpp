#pragma once
#include "page_facades.hpp"

namespace vldb_stage2 {
// Explicit specializations are selected by the original AnyFilter::Bind.
// The primary Query and its noinline DenseCall remain frozen. The dense loop
// below has the same bounds/dispatch and calls that SAME Base DenseCall; only
// the public-single branch takes the input element address directly.
#define PAGE_POINTER_QUERY(F) \
template<> __attribute__((noinline)) void Query<raw32_stage3::F>( \
    const raw32_stage3::F& filter,QueryMode mode,size_t n,const uint32_t* keys,uint32_t* out) { \
  if(mode==QueryMode::PublicSingle) { \
    for(size_t i=0;i<n;++i)out[i]=filter.SinglePointer(keys+i)?1u:0u; \
    return; \
  } \
  const typename raw32_stage3::F::Base& base=filter; \
  const uint32_t batch=mode==QueryMode::DenseBatch1?1:4096; \
  for(size_t i=0;i<n;i+=batch) { \
    const uint32_t count=static_cast<uint32_t>(std::min<size_t>(batch,n-i)); \
    DenseCall(base,count,keys+i,out+i); \
  } \
}
PAGE_POINTER_QUERY(Pointer4Default)
PAGE_POINTER_QUERY(Pointer4Compact)
PAGE_POINTER_QUERY(Pointer6Default)
PAGE_POINTER_QUERY(Pointer6Compact)
PAGE_POINTER_QUERY(Pointer8Default)
PAGE_POINTER_QUERY(Pointer8Compact)
#undef PAGE_POINTER_QUERY
} // namespace vldb_stage2
