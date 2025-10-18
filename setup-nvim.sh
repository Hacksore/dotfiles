#!/bin/bash

set -e

# Constants
APP_DIR="/app"
NVIM_BASE_DIR="$APP_DIR/nvim"

# URLs for different nvim versions
NIGHTLY_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
STABLE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

# Create separate directories for stable and nightly versions
STABLE_DIR="$NVIM_BASE_DIR/stable"
NIGHTLY_DIR="$NVIM_BASE_DIR/nightly"

mkdir -p "$STABLE_DIR" "$NIGHTLY_DIR"

# Download nvim versions
echo "Downloading Neovim stable..."
wget -q "$STABLE_URL" -O "$STABLE_DIR/nvim.tar.gz"

echo "Downloading Neovim nightly..."
wget -q "$NIGHTLY_URL" -O "$NIGHTLY_DIR/nvim.tar.gz"

# Extract nvim binaries
echo "Extracting stable version..."
tar xzf "$STABLE_DIR/nvim.tar.gz" -C "$STABLE_DIR" --strip-components=1

echo "Extracting nightly version..."
tar xzf "$NIGHTLY_DIR/nvim.tar.gz" -C "$NIGHTLY_DIR" --strip-components=1

# Create symlinks with different names
echo "Creating symlinks..."
ln -sf "$STABLE_DIR/bin/nvim" "/usr/local/bin/nvim-stable"
ln -sf "$NIGHTLY_DIR/bin/nvim" "/usr/local/bin/nvim-nightly"

echo "Neovim installation complete!"
echo "Use 'nvim-stable' for the stable version"
echo "Use 'nvim-nightly' for the nightly version"

