#!/bin/bash

# Load the installer dependency.
source dependencies/bash-package-installer/src/main.sh
source dependencies/bash-log/src/main.sh
source dependencies/bash-start-tor-at-boot/src/main.sh
source dependencies/bash-start-tor-at-boot/src/GLOBAL_VARS.sh # Superfluous
LOG_LEVEL_ALL                                                 # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

if [ -f "dependencies/bash-ssh-over-tor/src/main.sh" ]; then
  source dependencies/bash-ssh-over-tor/src/main.sh
fi

# Store arguments and then consume them to prevent the $@ argument from being
# parsed in the wrong parser that is loaded through another main.sh file.
CLI_ARGS_CREATE_ONION_DOMAINS=("$@")
while [ "$#" -gt 0 ]; do
  shift # Shift the arguments to move to the next one
done

# Load prerequisites installation.
function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$script_dir/configuration.sh"

  # shellcheck disable=SC1091
  source "$script_dir/parse_bash_onion_domains.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/create_onion_domain_dash.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/create_onion_domain_ssh.sh"

  # shellcheck disable=SC1091
  source "$script_dir/json_editing.sh"

  # shellcheck disable=SC1091
  source "$script_dir/json_to_torrc.sh"

}
load_functions
setup_onion_domain "${CLI_ARGS_CREATE_ONION_DOMAINS[@]}"
