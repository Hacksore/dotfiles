FROM node:trixie-slim

WORKDIR /app

# native deps
RUN apt update -y && apt install -y \
  curl unzip wget git file make cmake gcc clang \
  pkg-config build-essential \
  fd-find ripgrep fzf \
  libstdc++6 libc-dev


# copy setup script
COPY setup-nvim.sh ./

COPY ./test ./test

# setup nvim
RUN chmod +x setup-nvim.sh && ./setup-nvim.sh

# copy package files first
COPY pnpm-lock.yaml ./
COPY packages/hack ./

# install dependencies
RUN npm install -g pnpm && pnpm install

# copy configs
COPY ./.config/nvim/ ./localdotfiles/.config/nvim

ENTRYPOINT ["npx", "hack", "test"]
