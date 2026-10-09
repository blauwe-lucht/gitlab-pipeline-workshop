#!/usr/bin/env bash
# Checks that each solution equals the start of the next exercise (README.md excluded).
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
status=0

next_exercise_for() {
  local number=$((10#$1 + 1))
  compgen -G "$repo_root/exercises/$(printf '%02d' "$number")-*" || true
}

for solution in "$repo_root"/solutions/[0-9][0-9]-*/; do
  solution=${solution%/}
  next_exercise=$(next_exercise_for "$(basename "$solution" | cut -c1-2)")
  if [ -z "$next_exercise" ]; then
    continue
  fi
  if diff -r --exclude=README.md "$solution" "$next_exercise"; then
    echo "OK   $(basename "$solution") = $(basename "$next_exercise")"
  else
    echo "DIFF $(basename "$solution") != $(basename "$next_exercise")"
    status=1
  fi
done

exit "$status"
