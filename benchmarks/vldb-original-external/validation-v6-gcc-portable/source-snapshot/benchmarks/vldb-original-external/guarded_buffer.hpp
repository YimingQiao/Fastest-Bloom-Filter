#pragma once
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <type_traits>
#include <sys/mman.h>
#include <unistd.h>

namespace vldb_external {
// Correctness-only storage: the exact payload ends at a PROT_NONE page. Left
// slack is a checked canary. These guard pages are not a benchmark allocation.
template<class T> class GuardedBuffer {
  static_assert(std::is_trivially_copyable<T>::value,"guarded test values must be trivial");
  void* mapping_=MAP_FAILED;
  unsigned char* writable_=nullptr;
  T* data_=nullptr;
  size_t count_=0,bytes_=0,writable_bytes_=0,mapping_bytes_=0;
  static constexpr unsigned char Canary=0xa5;
public:
  explicit GuardedBuffer(size_t count):count_(count) {
    const long queried=::sysconf(_SC_PAGESIZE);
    if(queried<=0) throw std::runtime_error("invalid page size");
    const size_t page=static_cast<size_t>(queried);
    if(count>std::numeric_limits<size_t>::max()/sizeof(T)) throw std::overflow_error("guard payload overflow");
    bytes_=count*sizeof(T);
    if(bytes_>std::numeric_limits<size_t>::max()-3*page) throw std::overflow_error("guard mapping overflow");
    writable_bytes_=std::max(page,(bytes_+page-1)/page*page);
    mapping_bytes_=writable_bytes_+2*page;
    mapping_=::mmap(nullptr,mapping_bytes_,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(mapping_==MAP_FAILED) throw std::runtime_error("mmap guard buffer failed");
    writable_=static_cast<unsigned char*>(mapping_)+page;
    if(::mprotect(writable_,writable_bytes_,PROT_READ|PROT_WRITE)) {
      ::munmap(mapping_,mapping_bytes_);mapping_=MAP_FAILED;
      throw std::runtime_error("mprotect guard buffer failed");
    }
    std::memset(writable_,Canary,writable_bytes_);
    data_=reinterpret_cast<T*>(writable_+writable_bytes_-bytes_);
  }
  ~GuardedBuffer() { if(mapping_!=MAP_FAILED) ::munmap(mapping_,mapping_bytes_); }
  GuardedBuffer(const GuardedBuffer&)=delete;
  GuardedBuffer& operator=(const GuardedBuffer&)=delete;
  T* data() { return data_; }
  const T* data() const { return data_; }
  size_t size() const { return count_; }
  size_t payload_bytes() const { return bytes_; }
  size_t test_mapping_bytes() const { return mapping_bytes_; }
  void Fill(T value) { std::fill(data_,data_+count_,value); }
  void ReadOnly() {
    if(::mprotect(writable_,writable_bytes_,PROT_READ)) throw std::runtime_error("mprotect read-only input failed");
  }
  void CheckPrefix() const {
    const auto* end=reinterpret_cast<const unsigned char*>(data_);
    for(const auto* p=writable_;p<end;++p) if(*p!=Canary) throw std::runtime_error("guard prefix overwritten");
  }
};
} // namespace vldb_external
