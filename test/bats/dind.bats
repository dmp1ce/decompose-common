#!/usr/bin/env bats

TESTER_IMAGE="docker run --rm --link decompose-docker-common-testing:docker docker run --rm tester"

@test "project_root process" {
  run $TESTER_IMAGE sh -c "cd /app && \
decompose project-root"

  echo "$output"
  [ "${lines[1]}" = "/app" ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
