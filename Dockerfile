FROM node:trixie-slim

WORKDIR /app

# native deps
RUN apt update -y && apt install -y \
  curl unzip wget git file make cmake gcc clang \
  pkg-config build-essential \
  fd-find ripgrep fzf \
  libstdc++6 libc-dev

# copy configs
COPY ./.config ./localdotfiles/.config

# copy in hack cli
COPY ./packages/ ./packages/

# copy package files and install dependencies
RUN npm install -g pnpm && pnpm install

# setup nvim
RUN chmod +x setup-nvim.sh && ./setup-nvim.sh

ENTRYPOINT ["hack", "--help"]
