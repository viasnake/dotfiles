#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "dot help exits successfully" {
  run "$REPO_ROOT/script/dot" help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "dot unknown command fails" {
  run "$REPO_ROOT/script/dot" unknown

  [ "$status" -ne 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "dot bootstrap rejects extra argument" {
  run "$REPO_ROOT/script/dot" bootstrap extra

  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option:"* ]]
}
