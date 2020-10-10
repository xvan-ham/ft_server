FROM debian:buster 

RUN apt-get update

RUN apt-get -y upgrade

RUN apt-get -y install nginx

RUN apt-get -y install vim

RUN chown -R www-data /var/www/*

RUN chmod -R 755 /var/www/*

RUN mkdir /var/run/php

RUN apt-get -y install mariadb-server

# Php info based on: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04

RUN apt-get -y install php7.3 php7.3-fpm

COPY srcs/info.php /var/www/html/info.php

COPY srcs/index.html /var/www/html/index.html

COPY srcs/nginx.conf /etc/nginx/sites-available/default

# SSL key and self-signed certificate: rsa: length of key in bits; x509 create instead of generating sign-request; nodes: skip securing with passphrase which would interfere with servers automatic launch; days: key validity duration; keyout: key output location; out: certificate output location
# Based on: https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-debian-10
RUN mkdir /etc/nginx/ssl

RUN apt-get -y install openssl

RUN openssl req -new -x509 -days 365 -sha256 -nodes -out /etc/nginx/ssl/xvan-ham.pem -keyout /etc/nginx/ssl/xvan-ham.key -subj "/C=ES/ST=Madrid/L=Madrid/O=42 Madrid/OU=xvan-ham/CN=ft_server"

EXPOSE 80 443

ENTRYPOINT service nginx start && service php7.3-fpm start && service php7.3-fpm status && /bin/bash
