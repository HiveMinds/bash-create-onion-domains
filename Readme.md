# Sets onion domain over tor for different services

WIP!
Sets up an onion domain for:

- SSH access over Tor into this device
- Dash plots
- ..

## Creating Onion Domains

```sh
git clone https://github.com/HiveMinds/bash-ssh-over-tor.git
cd bash-create-onion-domains
chmod +x install-dependencies.sh
./install-dependencies.sh

chmod +x src/main.sh
src/main.sh --ssh --random
```

To generate a random new onion domain for the ssh service. Or to create an
onion domain for a dash website/plot:

```sh
src/main.sh --dash --random
```

### Reading Onion Domains

To see what the actual onion domain is, run:

```sh
src/main.sh --<your service> --get-onion
```

Like:

```sh
src/main.sh --ssh --get-onion
```

## Developer Information

Below is information for developers, e.g. how to use this as a dependency in
other projects.

### Install this bash dependency in other repo

- In your other repo, include a file named: `.gitmodules` that includes:

```sh
[submodule "dependencies/bash-ssh-over-tor"]
 path = dependencies/bash-ssh-over-tor
 url = https://github.com/hiveminds/bash-ssh-over-tor
```

- Create a file named `install-dependencies.sh` with content:

```sh
# Remove the submodules if they were still in the repo.
git rm --cached dependencies/bash-ssh-over-tor

# Remove and re-create the submodule directory.
rm -r "$SCRIPT_PATH/dependencies"/bash-ssh-over-tor
mkdir -p "$SCRIPT_PATH/dependencies"/bash-ssh-over-tor

# (Re) add the BATS submodules to this repository.
git submodule add --force https://github.com/hiveminds/bash-ssh-over-tor dependencies/bash-ssh-over-tor
```

- Install the submodule with:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh
```

### Call this bash dependency from other repo

After including this dependency you can use the functions in this module like:

```sh
#!/bin/bash

# Source the file containing the functions
source "$(dirname "${BASH_SOURCE[0]}")/src/main.sh"

# Naming conventions:
# server - The pc that you access and control.
# client - The pc that you use to control the server.

# Configure tor and ssh such that allows ssh access over tor.
configure_ssh_over_tor_at_boot
```

The `0` and `1` after the package name indicate whether it will update the
package manager afterwards (`0` = no update, `1` = package manager update after
installation/removal)

### Testing

Put your unit test files (with extension .bats) in folder: `/test/`

### Developer Prerequisites

(Re)-install the required submodules with:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh
```

Install:

```sh
sudo gem install bats
sudo apt install bats -y
sudo gem install bashcov
sudo apt install shfmt -y
pre-commit install
pre-commit autoupdate
```

### Pre-commit

Run pre-commit with:

```sh
pre-commit run --all
```

### Tests

Run the tests with:

```sh
bats test
```

If you want to run particular tests, you could use the `test.sh` file:

```sh
chmod +x test.sh
./test.sh
```

### Code coverage

```sh
bashcov bats test
```

## How to help

- Include bash code coverage in GitLab CI.
- Add [additional](https://pre-commit.com/hooks.html) (relevant) pre-commit hooks.
- Develop Bash documentation checks
  [here](https://github.com/TruCol/checkstyle-for-bash), and add them to this
  pre-commit.
