#!/bin/bash

# This module is a dependency for:
CREATE_ONION_DOMAINS_PARENT_DEPS=("bash-ssh-over-tor")
# This module has dependencies:
CREATE_ONION_DOMAINS_REQUIRED_DEPS=("bash-log" "bash-package-installer" "bash-start-tor-at-boot")

CREATE_ONION_DOMAINS_SRC_PATH=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
CREATE_ONION_DOMAINS_PATH=$(readlink -f "$CREATE_ONION_DOMAINS_SRC_PATH/../")

# Loads the bash log dependency, and the dependency loader.
function load_dependency_manager() {
  if [ -d "$CREATE_ONION_DOMAINS_PATH/dependencies/bash-log" ]; then
    # shellcheck disable=SC1091
    source "$CREATE_ONION_DOMAINS_PATH/dependencies/bash-log/src/dependency_manager.sh"
  elif [ -d "$CREATE_ONION_DOMAINS_PATH/../bash-log" ]; then
    # shellcheck disable=SC1091
    source "$CREATE_ONION_DOMAINS_PATH/../bash-log/src/main.sh"
  else
    echo "ERROR: bash-log dependency is not found."
    exit 1
  fi
}
load_dependency_manager

# Load required dependencies.
for required_dependency in "${CREATE_ONION_DOMAINS_REQUIRED_DEPS[@]}"; do
  load_required_dependency "$START_TOR_AT_BOOT_PATH" "$required_dependency"
done

# Load dependencies that can be a parent dependency (=this module is a
# dependency of that module/dependency).
for parent_dep in "${CREATE_ONION_DOMAINS_PARENT_DEPS[@]}"; do
  load_parent_dependency "calling_repo_root_path" "$START_TOR_AT_BOOT_PATH" "$parent_dep"
done

LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

# Store arguments and then consume them to prevent the $@ argument from being
# parsed in the wrong parser that is loaded through another main.sh file.
CLI_ARGS_CREATE_ONION_DOMAINS=("$@")
while [ "$#" -gt 0 ]; do
  shift # Shift the arguments to move to the next one
done

# Load prerequisites installation.
function load_functions() {

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/configuration.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/parse_bash_onion_domains.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/ssh/create_onion_domain_dash.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/ssh/create_onion_domain_ssh.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/json_editing.sh"

  # shellcheck disable=SC1091
  source "$CREATE_ONION_DOMAINS_SRC_PATH/json_to_torrc.sh"

}
load_functions
setup_onion_domain "${CLI_ARGS_CREATE_ONION_DOMAINS[@]}"
