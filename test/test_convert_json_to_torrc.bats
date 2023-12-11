#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source dependencies/bash-log/src/main.sh
source dependencies/bash-ssh-over-tor/src/main.sh
LOG_LEVEL_ALL

# Load the function that is to be tested.
source "src/json_to_torrc.sh"

# Describe block for testing the change_color function
@test "Test convert json to torrc lines." {

  input_json=$(
    cat <<EOF
{
  "dir": "some_directory/and_a_path",
  "local_port": 200,
  "public_port": 55
}
EOF
  )
  actual_torrc_lines="$(convert_json_project_to_torrc_lines "$input_json")"

  expected_lines=$(
    cat <<EOF
HiddenServiceDir some_directory/and_a_path
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
