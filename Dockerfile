FROM nginx

COPY ./srcs/nginx.conf /etc/nginx/nginx.conf

COPY ./srcs/index.html /usr/share/nginx/html