#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "project_root process" {
  cd "$WORKING"

  run decompose project-root

  echo "$output"
  [ "${lines[0]}" = "/tmp/"${BATS_TEST_NAME:0:216}"/build-test" ]
}

function setup() {
  setup_testing_environment
}

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
