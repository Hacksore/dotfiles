#!/bin/bash

# TODO: one thing to think about is could i make this all into a node script
# would allow me to easily write more complext logic like saving the diff result
# and creating some kind of upload to a static site or something
# but for now this is working and i want to keep it simple

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

# Determine dotfiles path based on LOCAL env var
if [[ "$LOCAL" == "1" ]]; then
  echo "🏠 Testing using local dotfiles"
  DOTFILES_PATH="$APP_DIR/localdotfiles/.config"
else
  git clone "$DOTFILES_REPO" "$APP_DIR/dotfiles"
  DOTFILES_PATH="$APP_DIR/dotfiles/.config"
fi

# link the dotfiles nvim config
ln -s "$DOTFILES_PATH/nvim" "$NVIM_CONFIG"

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

if [[ "$SKIP_CARGO" == "0" ]]; then
  # install rust and cargo
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
  . "$HOME/.cargo/env"

  # add cargo to PATH
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.bashrc"
fi

# Run nvim with TypeScript LSP test using TestTypescriptLSP command
# FIXME: this is a hack and we can't use auto installed cause it wont work in headless mode
# https://github.com/mason-org/mason-lspconfig.nvim/issues/456
# NOTE: this will catch breaking lua changes for neovim and exit with non-zero code
# and it should print out the error in the logs
CI=1 nvim --headless -e -c "MasonInstall typescript-language-server" -c 'exe !!v:errmsg."cquit"'

echo "Typescript LSP should be installed now, running validation test..."

# Compare original and generated lazy-lock.json (only if not using frozen lockfile)
if [[ "$FROZEN_LOCKFILE" == "0" ]]; then
  echo -e "📝 Lazy lock diff.\n"
  diff -u --color=always "$LAZY_LOCK_ORIGINAL" "$LAZY_LOCK_GENERATED" && echo $? || true

  # TODO: save diff result
fi

# run the lsp validation test
CI=1 nvim --headless -e -c "TestTypescriptLSP" -c 'exe !!v:errmsg."cquit"' "/app/__tests__/typescript/simple.ts"

echo -e "💻 Nvim version"
nvim -V1 -v
