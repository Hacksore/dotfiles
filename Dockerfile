FROM nginx:alpine
RUN mv bootstrap.sh index.html
COPY . /usr/share/nginx/html
