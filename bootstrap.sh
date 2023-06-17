#!/bin/bash

if [ -x "$(command -v apt-get)" ]; then
  apt-get update 
fi

# install git 
if [ ! -x "$(command -v git)" ]; then
  echo "Installing git..."
  apt-get install -y git
fi

# install curl
if [ ! -x "$(command -v curl)" ]; then
  echo "Installing curl..."
  apt-get install -y curl
fi

# clone the repo with dotfiles if not exists
if [ ! -d "$HOME/dotfiles" ]; then
  # on first clone you prolly don't have ssh keys setup let's use https
  git clone https://github.com/Hacksore/dotfiles.git "$HOME/dotfiles"
fi

if [ ! -d "$HOME/homebrew" ]; then
  # install unattended
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # install stow for configuration
  brew install stow

  # use brew bundle
  brew bundle --file "$HOME/dotfiles/Brewfile"
fi

# install the files with stow
stow .

# reset the url for dotiles to use ssh
cd "$HOME/dotfiles"
git remote set-url origin git@github.com:Hacksore/dotfiles.git

# done
echo "All config files have been linked..."
