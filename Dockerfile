FROM node

WORKDIR /app

COPY docs . 

RUN yarn

RUN yarn build
