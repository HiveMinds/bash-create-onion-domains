#!/bin/bash

parse_bash_onion_domains() {
  local setup_ssh_service="false"
  local setup_dash_service="false"
  local private_seed_filepath=""
  local private_key_filepath=""

  # Parse long options using getopt
  OPTS=$(getopt -o s:k:ssh:dash --long seed-path:,key-path:,ssh,dash -n 'parse-options' -- "$@")
  # shellcheck disable=SC2181
  if [ $? != 0 ]; then
    echo "Failed parsing options." >&2
    exit 1
  fi

  eval set -- "$OPTS"

  while true; do
    case "$1" in
      -ssh | --ssh)
        setup_ssh_service="true"
        shift
        ;;
      -dash | --dash)
        setup_dash_service="true"
        shift
        ;;
      -s | --seed-path)
        private_seed_filepath="$2"
        shift 2
        ;;
      -k | --key-path)
        private_key_filepath="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Invalid option: $1." >&2
        exit 1
        ;;
    esac
  done

  # Return values into a map.

  echo "$setup_ssh_service"
  echo "$setup_dash_service"
  echo "$private_seed_filepath"
  echo "$private_key_filepath"
}
