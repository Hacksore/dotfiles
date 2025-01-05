#!/bin/bash

mkdir -p ~/.config
git clone https://github.com/Hacksore/dotfiles.git /app/dotfiles

cd dotfiles || exit

ln -s /app/dotfiles/.config/nvim ~/.config/nvim

echo "Testing nvim version: $1"

NVIM_VERSION=$1

# chose stable or nightly based on env var
if [ "$NVIM_VERSION" = "nightly" ]; then
  curl -sLO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
elif [ "$NVIM_VERSION" = "stable" ]; then
  curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
fi

tar xzf nvim-linux64.tar.gz

mv ~/.config/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.original.json

# run in headless mode
CI=1 ./nvim-linux64/bin/nvim --headless -c 'exe !!v:errmsg."cquit"'

# # diff the original and the generated lazy-lock.json
echo "lazy diff lazy-lock.original.json -> lazy-lock.json"
diff -u --color ~/.config/nvim/lazy-lock.original.json ~/.config/nvim/lazy-lock.json && echo $? || true
