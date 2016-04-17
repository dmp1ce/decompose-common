#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "project_root process" {
  cd "$WORKING"

  run decompose project-root

  echo "$output"
  [ "${lines[0]}" = "/tmp/"${BATS_TEST_NAME:0:216}"/build-test" ]
}

@test "'decompose skel-get' updates skeleton files" {
  cd "$WORKING"

  # Load some data into the skeleton.
  touch "$WORKING/.decompose/environment/skel/test_file"

  run decompose skel-get test_file

  echo "$output"
  [ -f "$WORKING/test_file" ]
}

@test "'decompose skel-get' overrides existing files" {
  cd "$WORKING"

  # Create some test data
  echo "Original file" > "$WORKING/test_file"
  echo "Skeleton files" > "$WORKING/.decompose/environment/skel/test_file"

  decompose skel-get test_file

  local test_file_contents=$(cat "$WORKING/test_file")

  [ "$test_file_contents" == "Skeleton files" ]
}

@test "'decompose skel-get' overrides directories" {
  cd "$WORKING"

  # Create some test data
  mkdir -p "$WORKING/testdir"
  echo "Original file" > "$WORKING/testdir/test_file"
  mkdir -p "$WORKING/.decompose/environment/skel/testdir"
  echo "Skeleton files" > "$WORKING/.decompose/environment/skel/testdir/test_file"

  decompose skel-get testdir

  local test_file_contents=$(cat "$WORKING/testdir/test_file")

  echo "$test_file_contents"
  [ "$test_file_contents" == "Skeleton files" ]
}

@test "'decompose skel-put' updates skeleton files" {
  cd "$WORKING"

  # Load some data into the repository.
  touch "$WORKING/test_file"

  run decompose skel-put test_file

  echo "$output"
  [ -f "$WORKING/.decompose/environment/skel/test_file" ]
}

@test "'decompose skel-put' overrides existing files" {
  cd "$WORKING"

  # Create some test data
  echo "Original file" > "$WORKING/test_file"
  echo "Skeleton files" > "$WORKING/.decompose/environment/skel/test_file"

  decompose skel-put test_file

  local test_file_contents=$(cat "$WORKING/.decompose/environment/skel/test_file")

  [ "$test_file_contents" == "Original file" ]
}

@test "'decompose skel-put' overrides directories" {
  cd "$WORKING"

  # Create some test data
  mkdir -p "$WORKING/testdir"
  echo "Original file" > "$WORKING/testdir/test_file"
  mkdir -p "$WORKING/.decompose/environment/skel/testdir"
  echo "Skeleton files" > "$WORKING/.decompose/environment/skel/testdir/test_file"

  decompose skel-put testdir

  local test_file_contents=$(cat "$WORKING/.decompose/environment/skel/testdir/test_file")

  echo "$test_file_contents"
  [ "$test_file_contents" == "Original file" ]
}

function setup() {
  setup_testing_environment
}

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
