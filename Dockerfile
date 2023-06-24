FROM node

WORKDIR /app

COPY docs . 

RUN npm ci
