FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/

COPY bootstrap.sh /usr/share/nginx/html/index.html
