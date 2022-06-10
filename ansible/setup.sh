#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# setup the brew mod
ansible-galaxy collection install community.general

# TODO: test platform to run proper script
ansible-playbook install-mac.yaml
