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

# copy package files first for dependency caching
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/hack/package.json ./packages/hack/

# create minimal source structure for workspace linking
RUN mkdir -p packages/hack/src && echo 'export {}' > packages/hack/src/cli.ts

# install dependencies (this layer will be cached unless package files change)
RUN npm install -g pnpm && pnpm install

# copy actual source code after dependencies are installed
COPY packages/hack/src ./packages/hack/src
COPY packages/hack/tsconfig.json ./packages/hack/

# copy configs
COPY ./.config/nvim/ ./localdotfiles/.config/nvim

ENTRYPOINT ["npx", "hack", "test"]
