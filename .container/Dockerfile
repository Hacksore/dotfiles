FROM mcr.microsoft.com/devcontainers/base:jammy

ARG NODE_VERSION=24
ARG PNPM_VERSION=10.19.0

ENV HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew \
    HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar \
    HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew \
    HOMEBREW_NO_AUTO_UPDATE=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    SHELL=/usr/bin/zsh \
    PATH=/home/vscode/.local/share/fnm/aliases/default/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        file \
        locales \
        procps \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

USER vscode

RUN NONINTERACTIVE=1 CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

COPY --chown=vscode:vscode Brewfile.linux /tmp/Brewfile.linux
RUN brew bundle --file=/tmp/Brewfile.linux \
    && brew cleanup --prune=all \
    && rm -rf "$HOME/.cache/Homebrew" /tmp/Brewfile.linux

COPY --chown=vscode:vscode . /home/vscode/dotfiles

RUN rm -f "$HOME/.zprofile" "$HOME/.zshrc" \
    && cd "$HOME/dotfiles" \
    && stow --target="$HOME" .

RUN eval "$(fnm env --shell bash)" \
    && fnm install "${NODE_VERSION}" --use \
    && fnm default "${NODE_VERSION}" \
    && npm install --global "pnpm@${PNPM_VERSION}" \
    && npm cache clean --force \
    && node --version \
    && pnpm --version

RUN rustup toolchain install stable nightly \
    && rustup default stable

RUN cd "$HOME/dotfiles" \
    && pnpm install --frozen-lockfile

ENV PATH=/home/linuxbrew/.linuxbrew/opt/rustup/bin:/home/linuxbrew/.linuxbrew/opt/python/libexec/bin:${PATH}

USER root
RUN chsh --shell /usr/bin/zsh vscode

USER vscode
WORKDIR /home/vscode

CMD ["/usr/bin/zsh", "-l"]
