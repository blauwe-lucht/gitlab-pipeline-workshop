#!/usr/bin/env bash
# Usage: ci/configure.sh <Release|Debug> [extra CMake arguments...]
set -euo pipefail

build_type=$1
shift

conan profile detect --exist-ok
conan install . --output-folder=build --build=missing --settings=build_type="$build_type"
cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
  -DCMAKE_BUILD_TYPE="$build_type" "$@"
