#!/bin/bash
add_service_to_torrc() {
  local project_name="$1"
  local local_project_port="$2"
  local public_port_to_access_onion="$3"

  assert_is_non_empty_string "$public_port_to_access_onion"
  assert_is_non_empty_string "$local_project_port"

  create_torrc_lines_one_onion_per_service "$project_name" "$local_project_port" "$public_port_to_access_onion"
  prepare_onion_domain_creation "$project_name"
}

create_torrc_lines_one_onion_per_service() {
  local project_name="$1"
  local local_project_port="$2"
  local public_port_to_access_onion="$3"

  local torrc_line_1
  torrc_line_1="HiddenServiceDir $TOR_SERVICE_DIR/$project_name/"
  local torrc_line_2

  assert_is_non_empty_string "$public_port_to_access_onion"
  torrc_line_2="HiddenServicePort $public_port_to_access_onion 127.0.0.1:$local_project_port"

  # E. If that content is not in the torrc file, append it at file end.
  append_lines_if_not_found "$torrc_line_1" "$torrc_line_2" "$TORRC_FILEPATH"

  # F. Verify that content is in the file.
  verify_has_two_consecutive_lines "$torrc_line_1" "$torrc_line_2" "$TORRC_FILEPATH"
}

prepare_onion_domain_creation() {
  local project_name="$1"

  # Verify tor configuration file exists (Should be created at installation of
  # sudo apt tor).
  manual_assert_file_exists "$TORRC_FILEPATH" "true"

  #Create the project dir for the onion domain and verify it exists.
  sudo mkdir -p "$TOR_SERVICE_DIR/$project_name"
  manual_assert_dir_exists "$TOR_SERVICE_DIR/$project_name" "true"

  # Create the hostname file for the onion domain and verify it exists.
  sudo touch "$TOR_SERVICE_DIR/$project_name/hostname"
  manual_assert_file_exists "$TOR_SERVICE_DIR/$project_name/hostname" "true"

  # Make root owner of tor directory.
  sudo chown -R root "$TOR_SERVICE_DIR"
  sudo chmod 700 "$TOR_SERVICE_DIR/$project_name"

}
