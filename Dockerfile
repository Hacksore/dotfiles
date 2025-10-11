FROM ubuntu:24.04

WORKDIR /app

# native deps
RUN apt update -y && apt install -y \
  curl wget git file make cmake gcc clang \
  pkg-config build-essential \
  fd-find ripgrep nodejs fzf \
  libstdc++6 libc-dev

# copy configs
COPY ./.config ./localdotfiles/.config

# add in the test script and test files
COPY ./test-nvim.sh .
COPY ./__tests__ ./__tests__

RUN chmod +x test-nvim.sh

ENTRYPOINT ["/app/test-nvim.sh"]
