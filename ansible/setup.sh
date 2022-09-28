#!/bin/bash

# TODO: this wont work without an ssh key
git clone --bare git@github.com:Hacksore/dotfiles.git $HOME/.cfg

alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@"

config checkout

if [ $? = 0 ]; then
  echo "Checked out dotfiles 😎";
else
    echo "🛑 Please backup/remove these files first!"
fi;

config checkout
config config status.showUntrackedFiles no

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
ansible-playbook "$PWD/install-mac.yaml" --ask-become-pass --verbose
