#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source "$REPO_ROOT_PATH/"/bash-ssh-over-tor/src/main.sh
source "$REPO_ROOT_PATH/"/bash-start-tor-at-boot/src/main.sh
source "$REPO_ROOT_PATH/"/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
source "src/json_editing.sh"

# Describe block for testing the change_color function
@test "Test add a project to the single_entry json." {

  # Load the original single json.
  json_input_path="test/test_jsons_read/single_entry.json"
  manual_assert_file_exists "$json_input_path"
  json_output_path="test/test_jsons_write/single_entry.json"
  if [ -f "$json_output_path" ]; then
    rm "$json_output_path"
  fi
  manual_assert_file_not_exists "$json_output_path"

  # Create a new json project entry.
  local project_name="another_project_name"
  local directory="another_directory"
  local public_port=999
  local local_port=9001
  local new_json
  add_or_update_project_in_json "$json_input_path" "$json_output_path" "$project_name" "$directory" "$public_port" "$local_port"

  # Add the new json to the single_entry json.
  actual_merged_json="$(cat "$json_output_path")"
  expected_merged_json=$(
    cat <<EOF
{
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

# Describe block for testing the change_color function
@test "Test add a project to the triple_entry json." {

  # Load the original triple json.
  json_input_path="test/test_jsons_read/triple_entry.json"
  manual_assert_file_exists "$json_input_path"
  json_output_path="test/test_jsons_write/triple_entry.json"
  if [ -f "$json_output_path" ]; then
    rm "$json_output_path"
  fi
  manual_assert_file_not_exists "$json_output_path"

  # Create a new json project entry.
  local project_name="another_project_name"
  local directory="another_directory"
  local public_port=999
  local local_port=9001
  local new_json
  add_or_update_project_in_json "$json_input_path" "$json_output_path" "$project_name" "$directory" "$public_port" "$local_port"

  # Add the new json to the triple_entry json.
  actual_merged_json="$(cat "$json_output_path")"
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
