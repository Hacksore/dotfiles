FROM nginx:alpine

COPY mime.types /usr/share/nginx/mime.types
COPY mime.types /etc/nginx/mime.types

COPY bootstrap.sh /usr/share/nginx/html/index.html
