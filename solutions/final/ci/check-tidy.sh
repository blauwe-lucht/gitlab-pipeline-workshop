#!/usr/bin/env bash
set -euo pipefail

bash "$(dirname "$0")/configure.sh" Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
clang-tidy -p build src/*.cpp tests/*.cpp
