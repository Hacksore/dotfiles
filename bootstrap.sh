#!/bin/bash

# clone the repo with dotfiles if not exists
if [ -d "$HOME/dotfiles" ]; then
  git clone --recursive git@github.com:Hacksore/dotfiles.git "$HOME/dotfiles"
fi

if [ -d "$HOME/homebrew" ]; then
  git clone https://github.com/Homebrew/brew "$HOME/homebrew"

  cd $HOME
  eval "$(homebrew/bin/brew shellenv)"

  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"

  # install ansible and stow for configuration
  brew install ansible stow

  # setup the brew mod
  ansible-galaxy collection install community.general

  # brew just installed let's run our ansible stuff
  bash "$HOME/dotfiles/ansible/run.sh"

  # use brew bundle
  brew bundle --file "$HOME/dotfiles/Brewfile"

fi

# install the files with stow
stow .

# done
echo "All config files have been linked..."
