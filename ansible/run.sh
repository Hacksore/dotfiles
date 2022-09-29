#!/bin/bash

ansible-playbook "$HOME/dotfiles/ansible/install-mac.yaml" -i localhost, --ask-become-pass --verbose