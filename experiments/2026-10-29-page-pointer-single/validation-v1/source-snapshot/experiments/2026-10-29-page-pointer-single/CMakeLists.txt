cmake_minimum_required(VERSION 3.16)
project(page_pointer_single_control LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
get_filename_component(REPO "${CMAKE_CURRENT_SOURCE_DIR}/../.." ABSOLUTE)
set(BASE "${REPO}/benchmarks/vldb-raw32-stage3")
set(BACKEND "native" CACHE STRING "native or native-asan")
if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR NOT CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL "12.2.0")
  message(FATAL_ERROR "Use the same GCC12.2 toolchain as the frozen raw32 workers")
endif()
add_executable(page_pointer_control main.cpp)
target_include_directories(page_pointer_control PRIVATE "${BASE}" "${BASE}/native-snapshot/include"
 "${REPO}/benchmarks/boost-external/.deps/boost_1_92_0"
 "${REPO}/build/all-external-confirmation/_deps/fastfilter-src/src"
 "${REPO}/build/all-external-confirmation/_deps/pagebloom-src/include"
 "${REPO}/build/all-external-confirmation/_deps/pagebloom-src/src"
 "${REPO}/benchmarks/rocksdb-external/vendor" "${REPO}/benchmarks/rocksdb-external/vendor/include")
target_compile_definitions(page_pointer_control PRIVATE ROCKSDB_PLATFORM_POSIX OS_LINUX)
if(BACKEND STREQUAL "native")
  target_compile_options(page_pointer_control PRIVATE -O3 -march=native -fno-strict-aliasing)
elseif(BACKEND STREQUAL "native-asan")
  target_compile_options(page_pointer_control PRIVATE -O1 -march=native -fno-strict-aliasing -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer)
  target_link_options(page_pointer_control PRIVATE -fsanitize=address,undefined)
else()
  message(FATAL_ERROR "Unregistered backend")
endif()
