#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source "$REPO_ROOT_PATH/"/bash-log/src/main.sh
source "$REPO_ROOT_PATH/"/bash-ssh-over-tor/src/main.sh
LOG_LEVEL_ALL

# Load the function that is to be tested.
source "src/json_to_torrc.sh"

@test "Test convert single json project to torrc lines." {

  input_json=$(
    cat <<EOF
{
  "ssh": {
    "dir": "some_directory/and_a_path",
    "public_port": 321,
    "local_port": 123
  }
}
EOF
  )
  actual_torrc_lines="$(convert_projects_to_torrc "$input_json")"

  expected_lines=$(
    cat <<EOF
HiddenServiceDir some_directory/and_a_path
HiddenServicePort 321 127.0.0.1:123
EOF
  )

  if [ "$actual_torrc_lines" != "$expected_lines" ]; then
    NOTICE "actual_torrc_lines: $actual_torrc_lines"
    NOTICE "expected_lines:     $expected_lines"
    NOTICE "Assert output:\n\n"
  fi

  assert_equal "$actual_torrc_lines" "$expected_lines"
}

# Describe block for testing the change_color function
@test "Test convert three json projects to torrc lines." {
  input_json=$(
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
  actual_torrc_lines="$(convert_projects_to_torrc "$input_json")"

  expected_lines=$(
    cat <<EOF
HiddenServiceDir another_project_directory
HiddenServicePort 5 127.0.0.1:777
HiddenServiceDir another_directory
HiddenServicePort 999 127.0.0.1:9001
HiddenServiceDir some_directory
HiddenServicePort 55 127.0.0.1:200
EOF
  )

  if [ "$actual_torrc_lines" != "$expected_lines" ]; then
    NOTICE "actual_torrc_lines: $actual_torrc_lines"
    NOTICE "expected_lines:     $expected_lines"
    NOTICE "Assert output:\n\n"
  fi

  assert_equal "$actual_torrc_lines" "$expected_lines"
}
