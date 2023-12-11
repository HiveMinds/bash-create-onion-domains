#!/bin/bash

function convert_json_project_to_torrc_lines() {
  local json="$1"

  local dir
  local public_port
  local local_port

  # Extracting values from JSON
  dir=$(echo "$json" | jq -r '.dir')
  assert_is_non_empty_string "$dir"
  public_port=$(echo "$json" | jq -r '.public_port')
  assert_is_non_empty_string "$public_port"
  local_port=$(echo "$json" | jq -r '.local_port')
  assert_is_non_empty_string "$local_port"
  # Generating Torrc lines
  local torrc_line_1="HiddenServiceDir $dir"
  local torrc_line_2="HiddenServicePort $public_port 127.0.0.1:$local_port"

  # Outputting Torrc lines
  echo "$torrc_line_1"
  echo "$torrc_line_2"
}

function convert_projects_to_torrc() {
  local json_content="$1"

  # Loop over each project in the JSON
  for project in $(echo "$json_content" | jq -r 'keys[]'); do
    local dir
    local public_port
    local local_port

    # Extracting values for each project
    project_dict=$(echo "$json_content" | jq -r ".[\"$project\"]")
    assert_is_non_empty_string "$project_dict"

    convert_json_project_to_torrc_lines "$project_dict"
  done
}

function write_json_to_torrc() {
  local json_input_filepath="$1"
  local torrc_output_filepath="$2"

  manual_assert_file_exists "$json_input_filepath"

  local json_content
  json_content="$(load_json_from_file "$json_input_filepath")"
  NOTICE "Read json_content from $json_input_filepath"
  NOTICE "json_content=\n$json_content"
  assert_is_non_empty_string "$json_content"

  local torrc_content
  torrc_content="$(convert_projects_to_torrc "$json_content")"
  NOTICE "Converted json_content to torrc_content:\n$torrc_content"

  # Set the socksport.
  #echo "SocksPort $SOCKS_PORT" | sudo tee "$torrc_output_filepath" >/dev/null
  # echo "$torrc_content" | sudo tee -a "$torrc_output_filepath" >/dev/null # The a is for append.
  echo "$torrc_content" | sudo tee "$torrc_output_filepath" >/dev/null

  manual_assert_file_exists "$torrc_output_filepath"
  NOTICE "Wrote torrc_content to $torrc_output_filepath"
  NOTICE "Its content is:\n$(cat "$torrc_output_filepath")"
}

function set_user_permissions_on_torrc_file_and_json_torrc() {

  assert_is_non_empty_string "$TORRC_FILEPATH"
  assert_is_non_empty_string "$TORRC_JSON_FILEPATH"
  sudo touch "$TORRC_FILEPATH"
  sudo touch "$TORRC_JSON_FILEPATH"

  sudo chmod 777 "$TORRC_FILEPATH"
  sudo chmod 777 "$TORRC_JSON_FILEPATH"
}
