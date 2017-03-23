#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "project_root process" {
  cd "$WORKING"

  run decompose project-root

  echo "$output"
  # Check project root for both Linux and MacOS
  [[ "${lines[0]}" = "/tmp/"${BATS_TEST_NAME:0:216}"/build-test" || "${lines[0]}" = /private/var/*/${BATS_TEST_NAME:0:216}"/build-test" ]]
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


@test "diff ignore ignores specified skeleton files" {
  cd "$WORKING"

  # Modify diff ignored file
  echo "Modified" >> not-important-to-track.txt

  run decompose diff-skeleton

  # Output should not include modified file
  local lines_found=$(echo "$output" | grep "not-important-to-track.txt" | wc -l)
  [ "$lines_found" -eq 0 ]
}

@test "diff ignore ignores specified skeleton directories" {
  # Skip this test if diff does not contain the exclude directory feature
  if [ -z "$(diff --help | grep '\-\-exclude-directory')" ]; then
    skip "diff does not include support exclude directory feature"
  fi

  cd "$WORKING"

  # Create directory structure
  mkdir not-important-directory
  echo "Modified" >> not-important-directory/a

  # Ignore directory
  echo not-important-directory >> .decompose/skel-diff-ignore

  run decompose diff-skeleton

  # Output should not include modified file
  local lines_found=$(echo "$output" | grep "not-important-directory" | wc -l)
  echo "$output"
  [ "$lines_found" -eq 0 ]
}

@test "diff ignore ignores specified skeleton files" {
  cd "$WORKING"

  # Modify diff ignored file
  echo "Modified" >> not-important-to-track.txt

  run decompose diff-skeleton

  # Output should not include modified file
  local lines_found=$(echo "$output" | grep "not-important-to-track.txt" | wc -l)
  [ "$lines_found" -eq 0 ]
}

@test "diff ignore in .decompose ignores files" {
  cd "$WORKING"

  # Create new file
  echo "A new file to ignore in diff" >> a_new_file.txt
  # Create ignore file
  echo "a_new_file.txt" >> .decompose/skel-diff-ignore

  run decompose diff-skeleton

  # Output should not include modified file
  echo "$output"
  local lines_found=$(echo "$output" | grep "a_new_file.txt" | wc -l)
  [ "$lines_found" -eq 0 ]
}

@test "diff ignore in project root" {
  cd "$WORKING"

  # Create new file
  echo "A new file to ignore in diff" >> a_new_file2.txt
  # Create ignore file
  echo "a_new_file2.txt" >> .decompose-skel-diff-ignore

  run decompose diff-skeleton

  # Output should not include modified file
  echo "$output"
  local lines_found=$(echo "$output" | grep "a_new_file2.txt" | wc -l)
  [ "$lines_found" -eq 0 ]
}

@test "diff ignore works in for multiple ignore files" {
  cd "$WORKING"

  # Environment level
  # Modify diff ignored file
  echo "Modified" >> not-important-to-track.txt

  # Private project level - .decompose directory
  # Create new file
  echo "A new file to ignore in diff" >> a_new_file.txt
  # Create ignore file
  echo "a_new_file.txt" >> .decompose/skel-diff-ignore

  # Public project level - project root
  # Create new file
  echo "A new file to ignore in diff" >> a_new_file2.txt
  # Create ignore file
  echo "a_new_file2.txt" >> .decompose-skel-diff-ignore

  run decompose diff-skeleton

  # Output should not include modified file
  echo "$output"
  local lines_found=$(echo "$output" | grep "not-important-to-track.txt" | wc -l)
  [ "$lines_found" -eq 0 ]

  # Output should not include modified file
  echo "$output"
  local lines_found=$(echo "$output" | grep "a_new_file.txt" | wc -l)
  [ "$lines_found" -eq 0 ]

  # Output should not include modified file
  echo "$output"
  local lines_found=$(echo "$output" | grep "a_new_file2.txt" | wc -l)
  [ "$lines_found" -eq 0 ]
}

@test "Help functions do not output any errors" {
  cd "$WORKING"
  error_output=$(decompose --help 2>&1 >/dev/null)
  echo "$error_output"
  [ -z "$error_output" ]
}

function setup() {
  setup_testing_environment
}

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
