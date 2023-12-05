#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source "$REPO_ROOT_PATH/"/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
source "src/json_editing.sh"

# Describe block for testing the change_color function
@test "Test can overwrite a project in the single_entry json." {

  # Load the original single json.
  single_json="$(load_json_from_file "test/test_jsons_read/single_entry.json")"

  # Create a new json project entry.
  local project_name="ssh"
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
@test "Test can overwrite a project in the triple_entry json." {

  # Load the original triple json.
  triple_json="$(load_json_from_file "test/test_jsons_read/triple_entry.json")"

  # Create a new json project entry.
  local project_name="dash"
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
    "dir": "another_directory",
    "public_port": 999,
    "local_port": 9001
  },
  "ssh": {
    "dir": "some_directory",
    "local_port": 200,
    "public_port": 55
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
