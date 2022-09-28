#!/bin/bash

# installs homebrew to $HOME if not found
if ! [ -x "$(command -v brew)" ]; then
  cd $HOME
  git clone https://github.com/Homebrew/brew homebrew
  brew update --force --quiet
fi

# install ansible
brew install ansible

# setup the brew mod
ansible-galaxy collection install community.general

# run the install playbook
ansible-playbook install-mac.yaml --ask-become-pass --verbose
