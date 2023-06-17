FROM nginx:alpine
RUN ls -hal
COPY bootstrap.sh /usr/share/nginx/html/index.html
