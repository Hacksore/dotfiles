#!/bin/bash

mkdir -p ~/.config
git clone https://github.com/Hacksore/dotfiles.git /app/dotfiles

cd dotfiles || exit

ln -s /app/dotfiles/.config/nvim ~/.config/nvim
curl -sLO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz

mv /app/dotfiles/.config/nvim/lazy-lock.json /app/dotfiles/.config/nvim/lazy-lock.original.json

# run in headless mode
CI=1 ./nvim-linux64/bin/nvim --headless -c 'exe !!v:errmsg."cquit"'

# diff the original and the generated lazy-lock.json
echo "lazy diff lazy-lock.original.json -> lazy-lock.json"
diff /app/dotfiles/.config/nvim/lazy-lock.original.json /app/dotfiles/.config/nvim/lazy-lock.json 
