#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source dependencies/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
source "src/json_editing.sh"

# Describe block for testing the change_color function
@test "Test add a project to the single_entry json." {

  # Load the original single json.
  single_json="$(load_json_from_file "test/test_jsons_read/single_entry.json")"

  # Create a new json project entry.
  local project_name="new_project_name"
  local directory="new_directory"
  local public_port=321
  local local_port=123
  local new_json
  new_json="$(create_new_torrc_json_entry "$project_name" "$directory" "$public_port" "$local_port")"

  # Add the new json to the single_entry json.
  actual_merged_json="$(add_or_overwrite_torrc_json_project "$single_json" "$new_json")"
  expected_merged_json=$(
    cat <<EOF
{
  "ssh": {
    "dir": "some_directory",
    "local_port": 200,
    "public_port": 55
  },
  "new_project_name": {
    "dir": "new_directory",
    "public_port": 321,
    "local_port": 123
  }
}
EOF
  )

  if [ "$actual_merged_json" != "$expected_merged_json" ]; then
    NOTICE "actual_merged_json:   $actual_merged_json"
    NOTICE "expected_merged_json: $expected_merged_json"
    NOTICE "Assert output:\n\n"
  fi

  assert_equal "$actual_merged_json" "$expected_merged_json"
}

# Describe block for testing the change_color function
@test "Test add a project to the triple_entry json." {
  # Load the original triple json.
  triple_json="$(load_json_from_file "test/test_jsons_read/triple_entry.json")"

  # Create a new json project entry.
  local project_name="another_project_name"
  local directory="another_directory"
  local public_port=999
  local local_port=9001
  local new_json
  new_json="$(create_new_torrc_json_entry "$project_name" "$directory" "$public_port" "$local_port")"

  # Add the new json to the triple_entry json.
  actual_merged_json="$(add_or_overwrite_torrc_json_project "$triple_json" "$new_json")"
  expected_merged_json=$(
    cat <<EOF
{
  "another_project": {
    "dir": "another_project_directory",
    "local_port": 777,
    "public_port": 5
  },
  "dash": {
    "dir": "a_dash_directory",
    "local_port": 201,
    "public_port": 56
  },
  "ssh": {
    "dir": "some_directory",
    "local_port": 200,
    "public_port": 55
  },
  "another_project_name": {
    "dir": "another_directory",
    "public_port": 999,
    "local_port": 9001
  }
}
EOF
  )

  if [ "$actual_merged_json" != "$expected_merged_json" ]; then
    NOTICE "actual_merged_json:   $actual_merged_json"
    NOTICE "expected_merged_json: $expected_merged_json"
    NOTICE "Assert output:\n\n"
  fi

  assert_equal "$actual_merged_json" "$expected_merged_json"
}
