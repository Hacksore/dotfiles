FROM node:trixie-slim

WORKDIR /app

# native deps
RUN apt update -y && apt install -y \
  curl unzip wget git file make cmake gcc clang \
  pkg-config build-essential \
  fd-find ripgrep fzf \
  libstdc++6 libc-dev

# copy package files first
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/hack ./packages/hack/

# install dependencies
RUN npm install -g pnpm && pnpm install

# copy configs
COPY ./.config ./localdotfiles/.config

# copy setup script
COPY setup-nvim.sh ./

# setup nvim
RUN chmod +x setup-nvim.sh && ./setup-nvim.sh

ENTRYPOINT ["node", "packages/hack/src/cli.ts", "run"]
