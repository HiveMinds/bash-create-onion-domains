#!/bin/bash

function setup_onion_domain() {
  # Parse the CLI arguments for this module.

  declare -a parsed_args
  mapfile -t parsed_args < <(parse_bash_onion_domains "$@")
  local setup_ssh_service="${parsed_args[0]}"
  local setup_dash_service="${parsed_args[1]}"
  local get_onion_domain="${parsed_args[2]}"
  local random_domain="${parsed_args[3]}"
  local private_seed_filepath="${parsed_args[4]}"
  local private_key_filepath="${parsed_args[5]}"
  # Check if there are any arguments in parsed_args that are not empty strings.
  if [ "$(array_contains_non_empty_string "${parsed_args[@]}")" == "true" ]; then
    echo "ERROR: There are arguments that are not empty strings."
    exit 1
  fi

  # Check if a CLI argument is given.
  found_non_empty_string=false
  for arg in "${parsed_args[@]}"; do
    if [ -n "$arg" ]; then
      found_non_empty_string=true
      break
    fi
  done

  # If a CLI argument is given, then set the permissions of the torrc file.
  if [ "$found_non_empty_string" = false ]; then
    set_user_permissions_on_torrc_file_and_json_torrc
  fi

  if [ "$setup_ssh_service" == "true" ]; then

    if [ "$private_seed_filepath" != "" ]; then
      create_new_seeded_onion_domain_for_ssh "$private_seed_filepath"
    elif [ "$private_key_filepath" != "" ]; then
      restore_previous_onion_domain_for_ssh "$private_key_filepath"
    elif [ "$random_domain" == "true" ]; then
      create_new_random_onion_domain_for_ssh
    fi
    if [ "$get_onion_domain" == "true" ]; then
      get_onion_domain "ssh"
    fi
  fi

  if [ "$setup_dash_service" == "true" ]; then
    if [ "$private_seed_filepath" != "" ]; then
      create_new_seeded_onion_domain_for_dash "$private_seed_filepath"
    elif [ "$private_key_filepath" != "" ]; then
      restore_previous_onion_domain_for_dash "$private_key_filepath"
    elif [ "$random_domain" == "true" ]; then
      create_new_random_onion_domain_for_dash
    fi
    if [ "$get_onion_domain" == "true" ]; then
      get_onion_domain "dash"
    fi
  fi
}
