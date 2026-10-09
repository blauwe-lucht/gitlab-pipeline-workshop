#!/bin/sh
set -eu

CONFIG=/etc/gitlab-runner/config.toml
RUNNER_COUNT=2
GITLAB_INTERNAL_URL=http://gitlab:8929
DEFAULT_JOB_IMAGE=alpine:3.24.2

main() {
  if already_configured; then
    echo "Runners already configured, nothing to do."
    return
  fi

  access_token=$(create_access_token)
  require_token "$access_token" glpat- "access token"
  write_config "$access_token" > "$CONFIG.tmp"
  mv "$CONFIG.tmp" "$CONFIG"
  echo "Configured $RUNNER_COUNT runners in $CONFIG."
}

require_token() {
  case "$1" in
    "$2"*) ;;
    *) echo "Failed to create $3." >&2; exit 1 ;;
  esac
}

already_configured() {
  grep -q '^\[\[runners\]\]' "$CONFIG" 2>/dev/null
}

create_access_token() {
  echo "Creating access token (takes a minute)..." >&2
  docker exec "$GITLAB_CONTAINER" gitlab-rails runner "
    token = User.find_by_username('root').personal_access_tokens.create!(
      name: 'runner-init', scopes: [:create_runner], expires_at: 1.day.from_now)
    puts token.token
  " | tail -n 1
}

create_runner() {
  description=$1
  access_token=$2
  docker exec "$GITLAB_CONTAINER" curl --silent --fail \
    --header "PRIVATE-TOKEN: $access_token" \
    --data runner_type=instance_type \
    --data run_untagged=true \
    --data "description=$description" \
    http://localhost:8929/api/v4/user/runners \
    | sed -n 's/.*"token":"\([^"]*\)".*/\1/p'
}

write_config() {
  access_token=$1
  echo "concurrent = $RUNNER_COUNT"
  for i in $(seq 1 "$RUNNER_COUNT"); do
    name="workshop-runner-$i"
    runner_token=$(create_runner "$name" "$access_token")
    require_token "$runner_token" glrt- "runner token for $name"
    write_runner "$name" "$runner_token"
  done
}

write_runner() {
  cat <<EOF

[[runners]]
  name = "$1"
  url = "$GITLAB_INTERNAL_URL"
  clone_url = "$GITLAB_INTERNAL_URL"
  token = "$2"
  limit = 1
  executor = "docker"
  [runners.docker]
    image = "$DEFAULT_JOB_IMAGE"
    network_mode = "$DOCKER_NETWORK"
    pull_policy = ["if-not-present"]
    volumes = ["/cache"]
EOF
}

main
