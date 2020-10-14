# Base custom docker off of debian:buster image
FROM debian:buster 

# Update debian system
RUN apt-get update
RUN apt-get -y upgrade

# Install nginx
RUN apt-get -y install nginx

# Install mariadb-server (open source, community-developed, fork of MySQL: MariaDB).
RUN apt-get -y install mariadb-server

RUN mkdir /var/run/php 
#CHECK

# Install php, mysql and dependencies
# Php info based on: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04
RUN apt-get -y install php7.3 php7.3-fpm php7.3-mysql
RUN apt-get -y install php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip curl

# Install curl (to grab latest WordPress and phpMyAdmin)
RUN apt-get -y install curl

# Copy proof-of-success material: index.html is the basic html web-page that is set to be viewed first;info.php will show that php is set up correctly.
# To view this material, simply navigate to: http://localhost to view the html web-page; navigate to: http://localhost/info.php to view php info page (proving this service is working correctly.
COPY srcs/index.html /var/www/html/index.html
COPY srcs/info.php /var/www/html/info.php

# Copy CONFIG files (nginx, wordpress and php) 
COPY srcs/nginx.conf /etc/nginx/sites-available/default
COPY srcs/wp-config.php /tmp/
COPY srcs/config.inc.php /tmp/

# Download, extract and move wordpress to correct directory (removing downloaded .tar file after extraction).
RUN cd /tmp/ && curl -LO https://wordpress.org/latest.tar.gz && \
	tar xzvf latest.tar.gz && \
	rm latest.tar.gz
RUN mv /tmp/wordpress /var/www/html

# Move custom wordpress config file from /tmp/ folder to server directory.
RUN mv /tmp/wp-config.php /var/www/html/wordpress/wp-config.php

# Download, extract and move phpMyAdmin to correct directory (removing downloaded .tar file after extraction).
RUN cd /tmp/ && curl -LO https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
	cd /tmp/ &&	tar xzvf phpMyAdmin-latest-all-languages.tar.gz && \
	rm phpMyAdmin-latest-all-languages.tar.gz && \
	mv phpMyAdmin-*-all-languages /var/www/html/phpMyAdmin

# Move custom php config file from /tmp/ folder to server directory.
RUN mv /tmp/config.inc.php /var/www/html/phpMyAdmin/config.inc.php

# SSL key and self-signed certificate
# Setup correct https server.
# openssl switches explained:
# rsa: length of key in bits; x509 create instead of generating sign-request; nodes: skip securing with passphrase which would interfere with servers automatic launch; days: key validity duration; keyout: key output location; out: certificate output location
# Based on: https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-debian-10
RUN mkdir /etc/nginx/ssl
RUN apt-get -y install openssl
RUN openssl req -new -x509 -days 365 -sha256 -nodes -out /etc/nginx/ssl/xvan-ham.pem -keyout /etc/nginx/ssl/xvan-ham.key -subj "/C=ES/ST=Madrid/L=Madrid/O=42 Madrid/OU=xvan-ham/CN=ft_server"

# Assign permissions to web folders for the following user: www-data (user used by nginx).
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# Expose the corresponding ports: 80 is the default nginx server port, 443 is used for ssl verification (https).
EXPOSE 80 443

# When the docker image is run (docker run), run the following commands in the container:
# Start services and finish ssl config.
ENTRYPOINT echo "Starting Services" && \
			service mysql start && \
			echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password && \
			echo "GRANT ALL ON wordpress.* TO 'root'@'localhost';" | mysql -u root --skip-password && \
			echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password && \
			echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password &&\
			service nginx start && \
			service php7.3-fpm start && \
			service php7.3-fpm status && \
			/bin/bash
