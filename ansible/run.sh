#!/bin/bash

ansible-playbook "$HOME/dotfiles/ansible/mac.yaml" -i localhost, --ask-become-pass --verbose