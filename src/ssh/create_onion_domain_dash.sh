#!/bin/bash
create_new_random_onion_domain_for_dash() {
  echo "TODO: implement create_new_random_onion_domain for dash"
}

create_new_seeded_onion_domain_for_dash() {
  local private_seed="$1"
  ERROR "TODO: implement create_new_seeded_onion_domain for dash, private_seed=$private_seed"
  exit 1
}

restore_previous_onion_domain_for_dash() {
  local previous_onion_private_key="$1"
  ERROR "TODO: implement restore_previous_onion_domain for dash, previous_onion_private_key=$previous_onion_private_key"
  exit 1
}
