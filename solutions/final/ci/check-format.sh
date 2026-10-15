#!/usr/bin/env bash
set -euo pipefail

clang-format --dry-run --Werror src/*.cpp src/*.hpp tests/*.cpp
