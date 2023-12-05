#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source "$REPO_ROOT_PATH/"/bash-log/src/main.sh
LOG_LEVEL_ALL

# Load the script that contains the function to be tested
source "src/json_editing.sh"

# Describe block for testing the change_color function
@test "Test can read single_entry json file content." {

  # Call load_json function.
  single_json="$(load_json_from_file "test/test_jsons_read/single_entry.json")"
  expected_json=$(
    cat <<EOF
{
  "ssh": {
    "dir": "some_directory",
    "local_port": 200,
    "public_port": 55
  }
}
EOF
  )
  if [ "$single_json" != "$expected_json" ]; then
    NOTICE "single_json:   $single_json"
    NOTICE "expected_json: $expected_json"
  fi
  assert_equal "$single_json" "$expected_json"
}

@test "Test can read triple_entry json file content." {

  # Call load_json function.
  single_json="$(load_json_from_file "test/test_jsons_read/triple_entry.json")"
  expected_json=$(
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
  }
}
EOF
  )
  if [ "$single_json" != "$expected_json" ]; then
    NOTICE "single_json:   $single_json"
    NOTICE "expected_json: $expected_json"
  fi
  assert_equal "$single_json" "$expected_json"
}
