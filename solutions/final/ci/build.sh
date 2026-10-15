#!/usr/bin/env bash
set -euo pipefail

bash "$(dirname "$0")/configure.sh" Release
cmake --build build
