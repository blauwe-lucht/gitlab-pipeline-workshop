#!/usr/bin/env bash
set -euo pipefail

bash "$(dirname "$0")/configure.sh" Debug -DCMAKE_CXX_FLAGS=-fsanitize=address,undefined
# The app links statically, which the sanitizers do not support; the tests cover the same code.
cmake --build build --target roman_tests
./build/roman_tests
