#!/bin/bash

# used to test in a docker conainer

apt update -y
apt install curl git make cmake gcc fd-find ripgrep nodejs fzf -y
mkdir -p ~/.config
git clone https://github.com/Hacksore/dotfiles.git

cd dofiles

ln -s /dotfiles/.config/nvim ~/.config/nvim
curl -sLO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz

rm /dotfiles/.config/nvim/lazy-lock.json

# run in headless mode
CI=1 ./nvim-linux64/bin/nvim --headless -c 'exe !!v:errmsg."cquit"'
