#!/bin/bash

export HOMEBREW_PATH="/home/linuxbrew/.linuxbrew"
# NOTE: this exists but i don't know how to use it yet
# https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles

# install brew
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# load brew
eval "$($HOMEBREW_PATH/bin/brew shellenv)"

# set shell
sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

# clone dotfiles
git clone https://github.com/Hacksore/dotfiles.git ~/dotfiles

# install stow
brew install bundle
brew bundle --file=~/dotfiles/Brewfile.linux

# remove any zsh we don't want
rm ~/.zprofile
rm ~/.zshrc

# link configs
cd ~/dotfiles && stow .

# source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PATH/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PATH/opt/nvm/nvm.sh" # This loads nvm

# Remove the ssh signing as github has some stuff to handle it via gpg
git config --global credential.helper=/.codespaces/bin/gitcredential_github.sh
git config --global --unset user.signingkey
git config --global --unset commit.gpgsign
git config --global --unset gpg.format

# install node
nvm install 20 --lts
