#!/bin/bash

# clone the repo with dotfiles
git clone git@github.com:Hacksore/dotfiles.git "$HOME/dotfiles"

# install the files with stow
stow .