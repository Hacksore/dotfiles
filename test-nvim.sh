#!/bin/bash

set -e

mkdir -p ~/.config
git clone https://github.com/Hacksore/dotfiles.git /app/dotfiles

cd dotfiles || exit

# if LOCAL env set use the /app/localdotfiles folder
if [ -n "$LOCAL" ]; then
  echo "Testing using local dotfiles"
  DOTFILES_PATH="/app/localdotfiles/.config"
else
  DOTFILES_PATH="/app/dotfiles/.config"
fi

ln -s "$DOTFILES_PATH/nvim" ~/.config/nvim

echo "Testing nvim version: $1"
echo "Dotfiles path: $DOTFILES_PATH"

NVIM_VERSION="$1"

mkdir -p /app/nvim

# chose stable or nightly based on env var
if [ "$NVIM_VERSION" = "nightly" ]; then
  wget -q https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -O /app/nvim/nvim.tar.gz
elif [ "$NVIM_VERSION" = "stable" ]; then
  wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -O /app/nvim/nvim.tar.gz
fi

# extract and link neovim bin
tar xzf /app/nvim/nvim.tar.gz -C /app/nvim

if [ "$NVIM_VERSION" = "nightly" ]; then
  ln -s /app/nvim/nvim-linux-x86_64/bin/nvim /usr/bin
else
  ln -s /app/nvim/nvim-linux-x86_64/bin/nvim /usr/bin
fi

mv ~/.config/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.original.json

# run in headless mode
CI=1 nvim --headless -c 'exe !!v:errmsg."cquit"'

# diff the original and the generated lazy-lock.json
echo -e "\n\n---\n"

diff -u --color=always ~/.config/nvim/lazy-lock.original.json ~/.config/nvim/lazy-lock.json && echo $? || true

echo -e "Tested on nvim version:\n"
nvim -V1 -v
