#!/bin/bash

set -e

# Constants
NVIM_DIR="$APP_DIR/nvim"
NVIM_BIN_DIR="$NVIM_DIR/nvim-linux-x86_64/bin"
NVIM_TAR="$NVIM_DIR/nvim.tar.gz"

# URLs for different nvim versions
NIGHTLY_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
STABLE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

# Get nvim version from first argument
NVIM_VERSION="${1:-stable}"

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
