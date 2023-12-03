#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source dependencies/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
#load colors.sh

# Describe block for testing the change_color function
@test "Test single_entry json contains project ssh." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="ssh"
  # Call load_json function.
  single_json="$(load_json_from_file "test/test_jsons/single_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$single_json")"

  if [ "$actual_output" != "true" ]; then
    NOTICE "single_json:   $single_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "true"
}

@test "Test single_entry json does not contain project somename." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="somename"
  # Call load_json function.
  single_json="$(load_json_from_file "test/test_jsons/single_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$single_json")"

  if [ "$actual_output" != "false" ]; then
    NOTICE "single_json:   $single_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "false"
}

@test "Test triple_entry json contains project another_project." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="another_project"
  # Call load_json function.
  triple_json="$(load_json_from_file "test/test_jsons/triple_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$triple_json")"

  if [ "$actual_output" != "true" ]; then
    NOTICE "triple_json:   $triple_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "true"
}

@test "Test triple_entry json contains project ssh." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="ssh"
  # Call load_json function.
  triple_json="$(load_json_from_file "test/test_jsons/triple_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$triple_json")"

  if [ "$actual_output" != "true" ]; then
    NOTICE "triple_json:   $triple_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "true"
}

@test "Test triple_entry json contains project dash." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="dash"
  # Call load_json function.
  triple_json="$(load_json_from_file "test/test_jsons/triple_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$triple_json")"

  if [ "$actual_output" != "true" ]; then
    NOTICE "triple_json:   $triple_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "true"
}

@test "Test single_entry json does not contain project thisprojectdoesnotexist." {

  # Load the function that is to be tested.
  # shellcheck disable=SC1091
  source "src/json_editing.sh"

  tested_project_name="thisprojectdoesnotexist"
  # Call load_json function.
  triple_json="$(load_json_from_file "test/test_jsons/triple_entry.json")"
  actual_output="$(json_contains_project "$tested_project_name" "$triple_json")"

  if [ "$actual_output" != "false" ]; then
    NOTICE "triple_json:   $triple_json"
    NOTICE "tested_project_name:   $tested_project_name"
    NOTICE "actual_output: $actual_output"
  fi
  assert_equal "$actual_output" "false"
}
