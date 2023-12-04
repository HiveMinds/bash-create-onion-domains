#!/bin/bash

function load_json_from_file() {
  local json_filepath="$1"
  # TODO: assert the file exists
  manual_assert_file_exists "$json_filepath"

  # Load the json filecontent.
  if [ -f "$json_filepath" ]; then
    cat "$json_filepath"
  fi
}

# Function to check if JSON contains project or not
function json_contains_project() {
  local project_name="$1"
  local json="$2"

  if [[ $json == *"$project_name"* ]]; then
    echo "true"
  else
    echo "false"
  fi
}

function create_new_torrc_json_entry() {
  local project_name="$1"
  local directory="$2"
  local public_port="$3"
  local local_port="$4"

  local new_project='{
  "'"$project_name"'": {
    "dir": "'"$directory"'",
    "public_port": '"$public_port"',
    "local_port": '"$local_port"'
  }
}'

  echo "$new_project"
}

# Function to add project into JSON if it is not yet present
function add_or_overwrite_torrc_json_project() {
  local existing_json="$1" # Assuming existing_json is passed as an argument
  local new_project="$2"

  local updated_json
  updated_json=$(echo "$existing_json" | jq --argjson new_proj "$new_project" '. + $new_proj')
  echo "$updated_json"
}

# Function to manage adding/updating project details in JSON
function add_or_update_project_in_json() {
  local torrc_json_input_path="$1"
  local torrc_json_output_path="$2"
  local project_name="$3"
  local directory="$4"
  local public_port="$5"
  local local_port="$6"

  if [ -z "$project_name" ]; then
    ERROR "Error, project_name is empty."
    exit 1
  fi
  NOTICE "Checked project_name"
  if [ -z "$torrc_json_input_path" ]; then
    ERROR "Error, torrc_json_input_path name is empty."
    exit 1
  fi
  NOTICE "Checked torrc_json_input_path"
  # If the torrc_json_input_path file does not exist, create it.
  if [ ! -f "$torrc_json_input_path" ]; then
    NOTICE "torrc_json_input_path does not exist, creating it."
    sudo touch "$torrc_json_input_path"
  fi
  manual_assert_file_exists "$torrc_json_input_path"

  # TODO: specify jsonfilepath
  local existing_json
  existing_json="$(load_json_from_file "$torrc_json_input_path")"
  NOTICE "existing_json: $existing_json"

  # Create the new project entry.
  local new_torrc_json_project
  new_torrc_json_project="$(create_new_torrc_json_entry "$project_name" "$directory" "$public_port" "$local_port")"

  # Add or overwrite the project entry in the torrc.json file.
  actual_merged_json="$(add_or_overwrite_torrc_json_project "$existing_json" "$new_torrc_json_project")"

  echo "$actual_merged_json" >"$torrc_json_output_path"
  #sudo sh -c "echo \"$actual_merged_json\" > \"$torrc_json_output_path\""

  manual_assert_file_exists "$torrc_json_output_path"

  # TODO: assert file content of torrc_json_output_path equals actual_merged_json.
}
