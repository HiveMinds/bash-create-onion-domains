#!/bin/bash

function setup_onion_domain() {
  # Parse the CLI arguments for this module.

  set_user_permissions_on_torrc_file_and_json_torrc

  declare -a parsed_args
  mapfile -t parsed_args < <(parse_bash_onion_domains "$@")
  local setup_ssh_service="${parsed_args[0]}"
  local setup_dash_service="${parsed_args[1]}"
  local private_seed_filepath="${parsed_args[2]}"
  local private_key_filepath="${parsed_args[3]}"

  if [ "$setup_ssh_service" == "true" ]; then

    if [ "$private_seed_filepath" != "" ]; then
      create_new_seeded_onion_domain_for_ssh "$private_seed_filepath"
    elif [ "$private_key_filepath" != "" ]; then
      restore_previous_onion_domain_for_ssh "$private_key_filepath"
    else
      create_new_random_onion_domain_for_ssh
    fi
  fi

  if [ "$setup_dash_service" == "true" ]; then
    if [ "$private_seed_filepath" != "" ]; then
      create_new_seeded_onion_domain_for_dash "$private_seed_filepath"
    elif [ "$private_key_filepath" != "" ]; then
      restore_previous_onion_domain_for_dash "$private_key_filepath"
    else
      create_new_random_onion_domain_for_dash
    fi
  fi

  # TODO: Return the onion domain of Follower back into Leader.
  echo "Done creating onion domains."
}
