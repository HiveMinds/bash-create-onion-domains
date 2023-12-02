#!/bin/bash

# Load the installer dependency.
source dependencies/bash-package-installer/src/main.sh
source dependencies/bash-log/src/main.sh
source dependencies/bash-start-tor-at-boot/src/main.sh
source dependencies/bash-start-tor-at-boot/src/GLOBAL_VARS.sh # Superfluous
LOG_LEVEL_ALL                                                 # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

# Load prerequisites installation.
function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/create_onion_domain_dash.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/create_onion_domain_ssh.sh"

}
load_functions
create_new_random_onion_domain_for_ssh
