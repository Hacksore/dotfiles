FROM node as builder

WORKDIR /app
COPY docs . 
RUN yarn
RUN yarn build

FROM nginx:alpine as runner

COPY default.conf /etc/nginx/conf.d/
COPY --from=builder /app/dist /usr/share/nginx/html
