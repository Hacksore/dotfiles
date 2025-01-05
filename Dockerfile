FROM debian

WORKDIR /app

# native deps
RUN apt update -y && apt install curl git make cmake gcc fd-find ripgrep nodejs fzf -y

# we can use this to allow testing changes from the local working changes
COPY ./.config ./localdotfiles/.config

# add in the test script
COPY ./test-nvim.sh .

RUN chmod +x test-nvim.sh

ENTRYPOINT ["/app/test-nvim.sh"]
