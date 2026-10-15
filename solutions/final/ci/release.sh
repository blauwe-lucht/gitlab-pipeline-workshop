#!/usr/bin/env bash
# Runs in a GitLab tag pipeline: needs CI_COMMIT_TAG, CI_JOB_TOKEN, CI_API_V4_URL and CI_PROJECT_ID.
set -euo pipefail

if [ -z "${RELEASE_SECRET:-}" ]; then
  echo "RELEASE_SECRET is empty: is this tag protected?" >&2
  exit 1
fi

# Printed only to show masking in the job log; never print a real secret.
echo "Signing release with $RELEASE_SECRET"
curl --fail-with-body --header "JOB-TOKEN: $CI_JOB_TOKEN" --upload-file build/roman \
  "$CI_API_V4_URL/projects/$CI_PROJECT_ID/packages/generic/roman/$CI_COMMIT_TAG/roman"
