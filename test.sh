#!/usr/bin/env bash
./install-dependencies.sh
# Run this file to run all the tests, once
./test/libs/bats/bin/bats test/*.bats
