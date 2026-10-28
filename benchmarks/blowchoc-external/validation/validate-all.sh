#!/usr/bin/env bash
set -euo pipefail
cd /home/yiming/projects/fastest-bf-lab
cmake -S benchmarks/blowchoc-external -B build/blowchoc-bridge -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release
cmake --build build/blowchoc-bridge -j1
ctest --test-dir build/blowchoc-bridge --output-on-failure
cmake -S benchmarks/blowchoc-external -B build/blowchoc-bridge-scalar -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release -DBLOWCHOC_NATIVE=OFF
cmake --build build/blowchoc-bridge-scalar -j1
ctest --test-dir build/blowchoc-bridge-scalar --output-on-failure
benchmarks/blowchoc-external/.venv/bin/python benchmarks/blowchoc-external/check_bridge.py --native build/blowchoc-bridge-scalar/libblowchoc_native.so --native-only --report build/blowchoc-bridge/check-scalar.json
cmake -S benchmarks/blowchoc-external -B build/blowchoc-bridge-asan -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBLOWCHOC_SANITIZE=ON
cmake --build build/blowchoc-bridge-asan -j1
ctest --test-dir build/blowchoc-bridge-asan --output-on-failure
benchmarks/blowchoc-external/.venv/bin/python benchmarks/blowchoc-external/run.py --native build/blowchoc-bridge/libblowchoc_native.so --output build/blowchoc-bridge/accuracy.json
