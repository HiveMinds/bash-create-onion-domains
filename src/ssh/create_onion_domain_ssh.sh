#!/bin/bash
create_new_random_onion_domain_for_ssh() {
  NOTICE "TODO: implement create_new_random_onion_domain for ssh"

  add_service_to_torrc "$project_name" "$local_project_port" "$public_port_to_access_onion"
  ensure_onion_domain_is_created_by_starting_tor "ssh"
}

create_new_seeded_onion_domain_for_ssh() {
  local private_seed="$1"
  ERROR "TODO: implement create_new_seeded_onion_domain for ssh, private_seed=$private_seed"
  exit 1
}

restore_previous_onion_domain_for_ssh() {
  local previous_onion_private_key="$1"
  ERROR "TODO: implement restore_previous_onion_domain for ssh, previous_onion_private_key=$previous_onion_private_key"
  exit 1
}

ensure_onion_domain_is_created_by_starting_tor() {
  local project_name="$1"
  kill_tor_if_already_running
  assert_tor_is_not_running
  NOTICE "TOR_SERVICE_DIR=$TOR_SERVICE_DIR"
  NOTICE "TOR_LOG_FILEPATH=$TOR_LOG_FILEPATH"

  # TODO: include max_tor_wait_time as parameter
  local wait_time_sec=260

  local onion_domain
  NOTICE "Now starting tor, and waiting (max) $wait_time_sec seconds to generate onion url locally."

  # Start "sudo tor" in the background
  sudo tor | tee "$TOR_LOG_FILEPATH" >/dev/null &
  NOTICE "Started tor in the background. You can inspect the log file at:$TOR_LOG_FILEPATH"

  # Set the start time of the function
  local start_time
  start_time=$(date +%s)

  # Check if the onion URL exists in the hostname every 5 seconds, until 2 minutes have passed
  while true; do
    local onion_exists
    onion_exists=$(check_onion_url_exists_in_hostname "$project_name")

    # Check if the onion URL exists in the hostname
    if sudo test -f "$TOR_SERVICE_DIR/$project_name/hostname"; then
      if [[ "$onion_exists" == "FOUND" ]]; then

        onion_domain="$(get_onion_domain "$project_name")"

        # If the onion URL exists, terminate the "sudo tor" process and return 0
        kill_tor_if_already_running
        NOTICE "Successfully created your onion domain locally. Proceeding.."
        sleep 5

        # TODO: verify the private key is valid for the onion domain.
        # TODO: verify whether it is reachable over tor.
        return 0
      else
        NOTICE "The file $TOR_SERVICE_DIR/$project_name/hostname exists, but its content is not a valid onion URL."
      fi
    else
      NOTICE "The file $TOR_SERVICE_DIR/$project_name/hostname does not exist."
    fi

    sleep 1

    # Calculate the elapsed time from the start of the function
    elapsed_time=$(($(date +%s) - start_time))

    # If 2 minutes have passed, raise an exception and return 7
    if ((elapsed_time > wait_time_sec)); then
      kill_tor_if_already_running
      ERROR "Error: Onion URL:$onion_domain does not exist in hostname after $wait_time_sec seconds."
      exit 6
    fi

    # Wait for 5 seconds before checking again
    sleep 5
  done

}
