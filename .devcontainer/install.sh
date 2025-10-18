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

# install stow
brew install stow

# remove any zsh we don't want
rm ~/.zprofile ~/.zshrc

if [[ "$GITHUB_REPOSITORY" = "Hacksore/dotfiles" ]]; then
  echo "Using workspace dotfiles cause you are working on that repo"
  # if we are in a codespace for our dotfiles we should always use the codespace to lin
  cd /workspaces/dotfiles && stow --target="$HOME" .
  DOTFILE_HOME="/workspaces/dotfiles"
else 
  echo "Using Hacksore/dotfiles cause your not in that codespace"
  # if we are in some other workspace always use the remote dotfiles
  # clone dotfiles
  git clone https://github.com/Hacksore/dotfiles.git ~/dotfiles
  cd "$HOME/dotfiles" && stow .
  DOTFILE_HOME="$HOME/dotfiles"
fi

brew bundle --file="$DOTFILE_HOME/Brewfile.linux"


# source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PATH/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PATH/opt/nvm/nvm.sh" # This loads nvm

# Remove the ssh signing as github has some stuff to handle it via gpg
git config --global credential.helper=/.codespaces/bin/gitcredential_github.sh
git config --global --unset user.signingkey
git config --global --unset commit.gpgsign
git config --global --unset gpg.format

# install node
nvm install 24 --lts

# install rust up
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# source the rust env
. "$HOME/.cargo/env"

# install stable+nightly
rustup install stable
rustup install nightly

# move to the right dotfile repo and then pnpm i
if [[ "$GITHUB_REPOSITORY" = "Hacksore/dotfiles" ]]; then
  cd /workspaces/dotfiles
else
  cd ~/dotfiles
fi

pnpm install