FROM gerault/docker-php5-fpm:latest 
MAINTAINER Mathieu GERAULT <mathieu.gerault@gmail.com>
LABEL Description="TinyTinyRSS PHP from Mathieu GERAULT"

# change ownership to www-data
RUN chown www-data:www-data /var/www/html

# change user from root to www-data
USER www-data

# go to the web directory, download tinytinyrss app
RUN cd /var/www/html \
	&& git clone https://tt-rss.org/git/tt-rss.git tt-rss 

# volume
VOLUME /var/www/html/tt-rss
