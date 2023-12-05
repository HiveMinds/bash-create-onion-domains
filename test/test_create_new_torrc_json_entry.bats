#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source "$REPO_ROOT_PATH/"/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
source "src/json_editing.sh"

# Describe block for testing the change_color function
@test "Test create a new single entry json." {
  # Call load_json function.
  expected_json=$(
    cat <<EOF
{
  "new_project_name": {
    "dir": "new_directory",
    "public_port": 321,
    "local_port": 123
  }
}
EOF
  )
  local project_name="new_project_name"
  local directory="new_directory"
  local local_port=123
  local public_port=321

  # Add the new json to the single_entry json.
  local actual_json
  actual_json="$(create_new_torrc_json_entry "$project_name" "$directory" "$public_port" "$local_port")"

  if [ "$expected_json" != "$actual_json" ]; then
    NOTICE "actual_json:   $actual_json"
    NOTICE "expected_json: $expected_json"
  fi
  assert_equal "$actual_json" "$expected_json"
}
