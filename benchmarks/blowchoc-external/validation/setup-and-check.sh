#!/usr/bin/env bash
set -euo pipefail
cd /home/yiming/projects/fastest-bf-lab
/home/yiming/.local/bin/uv venv --python /home/yiming/.local/share/uv/python/cpython-3.12.12-linux-x86_64-gnu/bin/python3.12 benchmarks/blowchoc-external/.venv
/home/yiming/.local/bin/uv pip install --python benchmarks/blowchoc-external/.venv/bin/python -r benchmarks/blowchoc-external/requirements.txt
cmake -S benchmarks/blowchoc-external -B build/blowchoc-bridge -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release
cmake --build build/blowchoc-bridge -j1
benchmarks/blowchoc-external/.venv/bin/python benchmarks/blowchoc-external/check_bridge.py --native build/blowchoc-bridge/libblowchoc_native.so --report build/blowchoc-bridge/check-native.json
