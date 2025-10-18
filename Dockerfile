FROM node:trixie-slim AS base

WORKDIR /app

# native deps
RUN apt update -y && apt install -y \
  curl unzip wget git file make cmake gcc clang \
  pkg-config build-essential \
  fd-find ripgrep fzf \
  libstdc++6 libc-dev

# Install pnpm
RUN npm install -g pnpm

# copy setup script
COPY setup-nvim.sh ./
COPY ./test ./test

# setup nvim
RUN chmod +x setup-nvim.sh && ./setup-nvim.sh

# Prune stage - create a pruned workspace
FROM base AS pruner
WORKDIR /app
COPY . .
RUN npx turbo prune @hack/cli --docker

# Install stage - install dependencies in pruned workspace
FROM base AS installer
WORKDIR /app
COPY --from=pruner /app/out/json/ .
COPY --from=pruner /app/out/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --from=pruner /app/out/full/ .
RUN pnpm install --frozen-lockfile

# Runtime stage - copy everything from installer
FROM base AS runner
WORKDIR /app
COPY --from=installer /app/ .

# copy configs
COPY ./.config/nvim/ ./localdotfiles/.config/nvim

ENTRYPOINT ["npx", "hack", "test"]
