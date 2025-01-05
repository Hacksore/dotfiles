#!/bin/bash

mkdir -p ~/.config
git clone https://github.com/Hacksore/dotfiles.git /app/dotfiles

cd dotfiles || exit

ln -s /app/dotfiles/.config/nvim ~/.config/nvim
curl -sLO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz

rm /app/dotfiles/.config/nvim/lazy-lock.json

# run in headless mode
CI=1 ./nvim-linux64/bin/nvim --headless -c 'exe !!v:errmsg."cquit"'
