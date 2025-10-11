#!/bin/bash

set -e

# Constants
DOTFILES_REPO="https://github.com/Hacksore/dotfiles.git"
APP_DIR="/app"
NVIM_DIR="$APP_DIR/nvim"
NVIM_BIN_DIR="$NVIM_DIR/nvim-linux-x86_64/bin"
NVIM_TAR="$NVIM_DIR/nvim.tar.gz"
CONFIG_DIR="$HOME/.config"
NVIM_CONFIG="$CONFIG_DIR/nvim"
LAZY_LOCK_ORIGINAL="$NVIM_CONFIG/lazy-lock.original.json"
LAZY_LOCK_GENERATED="$NVIM_CONFIG/lazy-lock.json"

# URLs for different nvim versions
NIGHTLY_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
STABLE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

# Get nvim version from first argument
NVIM_VERSION="${1:-stable}"

# Setup dotfiles
mkdir -p "$CONFIG_DIR"
git clone "$DOTFILES_REPO" "$APP_DIR/dotfiles"

# Determine dotfiles path based on LOCAL env var
if [ -n "$LOCAL" ]; then
  echo "Testing using local dotfiles"
  DOTFILES_PATH="$APP_DIR/localdotfiles/.config"
else
  DOTFILES_PATH="$APP_DIR/dotfiles/.config"
fi

ln -s "$DOTFILES_PATH/nvim" "$NVIM_CONFIG"

echo "Testing nvim version: $NVIM_VERSION"
echo "Dotfiles path: $DOTFILES_PATH"
echo "Frozen Lockfile: $FROZEN_LOCKFILE"
echo "Local: $LOCAL"

# Download and install nvim
mkdir -p "$NVIM_DIR"

case "$NVIM_VERSION" in
"nightly")
  wget -q "$NIGHTLY_URL" -O "$NVIM_TAR"
  ;;
"stable")
  wget -q "$STABLE_URL" -O "$NVIM_TAR"
  ;;
*)
  echo "Invalid nvim version: $NVIM_VERSION. Use 'stable' or 'nightly'"
  exit 1
  ;;
esac

# Extract and link nvim binary
tar xzf "$NVIM_TAR" -C "$NVIM_DIR"
ln -s "$NVIM_BIN_DIR/nvim" /usr/bin

if [[ "$FROZEN_LOCKFILE" == "1" ]]; then
  echo "FROZEN_LOCKFILE (ON): using existing lockfile without modification"
else
  echo "FROZEN_LOCKFILE (OFF): backing up original lazy-lock.json for comparison"
  mv "$LAZY_LOCK_GENERATED" "$LAZY_LOCK_ORIGINAL"
fi

# install rust and nighlyl
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
# . "$HOME/.cargo/env"  
#
# # add cargo to PATH
# echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"

# Run nvim with TypeScript LSP test using ValidateLSP command
CI=1 nvim --headless +"MasonInstall typescript-language-server" +q
CI=1 nvim --headless -c "ValidateLSP" -c 'exe !!v:errmsg."cquit"' "/app/__tests__/typescript/simple.ts"

# Compare original and generated lazy-lock.json (only if not using frozen lockfile)
if [[ "$FROZEN_LOCKFILE" == "0" ]]; then
  diff -u --color=always "$LAZY_LOCK_ORIGINAL" "$LAZY_LOCK_GENERATED" && echo $? || true
fi

ls -hal

echo -e "Tested on nvim version:\n"
nvim -V1 -v
