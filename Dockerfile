FROM debian

WORKDIR /app

COPY ./test-nvim.sh .

RUN chmod +x test-nvim.sh
RUN apt update -y && apt install curl git make cmake gcc fd-find ripgrep nodejs fzf -y

ENTRYPOINT "/app/test-nvim.sh"
