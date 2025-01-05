FROM debian

WORKDIR /app

COPY ./test-nvim.sh .

RUN chmod +x test-nvim.sh
RUN ls -hal /app

ENTRYPOINT "/app/test-nvim.sh"
