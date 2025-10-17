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

# copy package files and install dependencies
COPY ./package.json ./pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

# setup nvim
COPY ./setup-nvim.sh .
RUN chmod +x setup-nvim.sh && ./setup-nvim.sh

# add in the test script and test files
COPY ./test-nvim.ts .
COPY ./test ./test

RUN chmod +x test-nvim.ts

ENTRYPOINT ["node", "test-nvim.ts"]
