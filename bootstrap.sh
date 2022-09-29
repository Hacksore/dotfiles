#!/bin/bash

# clone the repo with dotfiles if not exists
# TODO: does this work if no ssh-key
if [ -d "$HOME/dotfiles" ]; then
  git clone git@github.com:Hacksore/dotfiles.git "$HOME/dotfiles"
fi

# install the files with stow
stow .