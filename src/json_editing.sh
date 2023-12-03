#!/bin/bash

function load_json_from_file() {
  local json_filepath="$1"
  # TODO: assert the file exists

  # Load the json filecontent.
  if [ -f "$json_filepath" ]; then
    echo "$(cat "$json_filepath")"
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

# Function to add project into JSON if it is not yet present
function add_project_to_json() {
  local project_name="$1"
  local directory="$2"
  local public_port="$3"
  local local_port="$4"
  local existing_json="$5"

  local new_project='{
        "'"$project_name"'": {
            "dir": "'"$directory"'",
            "public_port": '"$public_port"',
            "local_port": '"$local_port"'
        }
    }'

  local updated_json
  updated_json=$(echo "$existing_json" | jq --argjson new_proj "$new_project" '. + $new_proj')
  echo "$updated_json"
}

# Function to overwrite JSON project
function overwrite_json_project() {
  local updated_json="$1"
  echo "$updated_json" >project_config.json
}

# Function to manage adding/updating project details in JSON
function manage_project_json() {
  local project_name="$1"
  local directory="$2"
  local public_port="$3"
  local local_port="$4"

  # TODO: specify jsonfilepath
  local existing_json
  existing_json="$(load_json_from_file)"
  local contains_project
  contains_project=$(json_contains_project "$project_name" "$existing_json")

  local updated_json
  if [ "$contains_project" = "true" ]; then
    updated_json=$(add_project_to_json "$project_name" "$directory" "$public_port" "$local_port" "$existing_json")
    overwrite_json_project "$updated_json"
  else
    local new_project
    new_project='{
            "'"$project_name"'": {
                "dir": "'"$directory"'",
                "public_port": '"$public_port"',
                "local_port": '"$local_port"'
            }
        }'
    echo "$new_project" >project_config.json
  fi

  echo "Project '$project_name' details added to JSON file."
}
