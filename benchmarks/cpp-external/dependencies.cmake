include_guard(GLOBAL)
option(BF_PAGE_AES "Use PageBloom AES-NI hash" OFF)
include(FetchContent)
FetchContent_Declare(fastfilter
  URL https://codeload.github.com/FastFilter/fastfilter_cpp/tar.gz/7c5bf187d5096ccbcec6a16e02975d0af3328b01
  URL_HASH SHA256=3c8fcad833960dee276a6500b6c93a54c9e00d66678d4c66d7e0785e451c11f4)
FetchContent_Declare(pagebloom
  URL https://codeload.github.com/PeterRK/PageBloomFilter/tar.gz/bcf10622ab740b4dfd99631b27484ecedb96646a
  URL_HASH SHA256=080c05f5e82a51898426009560b306ad4419561071e59f2ad61751cdf2596450)
# Fetch only. Do not inherit upstream benchmark flags, tests, or dependencies.
FetchContent_GetProperties(fastfilter)
if(NOT fastfilter_POPULATED)
  FetchContent_Populate(fastfilter)
endif()
FetchContent_GetProperties(pagebloom)
if(NOT pagebloom_POPULATED)
  FetchContent_Populate(pagebloom)
endif()
add_library(fastfilter_external_options INTERFACE)
add_library(FastFilterExternal::options ALIAS fastfilter_external_options)
target_include_directories(fastfilter_external_options INTERFACE
  ${CMAKE_CURRENT_LIST_DIR} ${CMAKE_CURRENT_LIST_DIR}/../../include
  ${fastfilter_SOURCE_DIR}/src ${pagebloom_SOURCE_DIR}/include ${pagebloom_SOURCE_DIR}/src)

if(BF_PAGE_AES)
  target_compile_definitions(fastfilter_external_options INTERFACE USE_AESNI_HASH=1)
  target_compile_options(fastfilter_external_options INTERFACE -maes -mssse3)
endif()
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/licenses)
configure_file(${fastfilter_SOURCE_DIR}/LICENSE ${CMAKE_CURRENT_BINARY_DIR}/licenses/FastFilter-LICENSE COPYONLY)
configure_file(${pagebloom_SOURCE_DIR}/LICENSE ${CMAKE_CURRENT_BINARY_DIR}/licenses/PageBloomFilter-LICENSE COPYONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/upstreams.json ${CMAKE_CURRENT_BINARY_DIR}/cpp_external_upstreams.json COPYONLY)
