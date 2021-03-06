# docker-tinytinyrss-php5-fpm
This docker image comes from my custom php5-fpm image.

It embedds the tinytinyrss program (https://tt-rss.org/)

The locales and timezone are french.

This php image should be used with a web server container and a database container (for example, mysql).

## docker-compose
You will find below an example of my docker-compose file.
I use a nginx web server and a mysql instance.
As the configuration of the database is stored in the php files, I use a volume to make the persistence.
I use a second volume to persist the database

```
version: '2'
services:
        nginx:
                image: gerault/docker-nginx:latest
                container_name: tinytinyrss_nginx_prod
                restart: always
                ports:
                        - "8082:80"
                volumes:
                        - ./conf_files/site.conf:/etc/nginx/conf.d/site.conf:ro
                volumes_from:
                        - php
                links:
                        - php

        php:
                image: gerault/docker-tinytinyrss-php5-fpm:latest
                container_name: tinytinyrss_php_prod
                restart: always
                volumes:
                        - myphpdata:/var/www/html/tt-rss
                links:
                        - mysql-db

        mysql-db:
                image: mysql:5.7
                container_name: tinytinyrss_mysql_prod
                restart: always
                volumes:
                        - mysqldata:/var/lib/mysql
                environment:
                        - MYSQL_ROOT_PASSWORD=rootpwd
                        - MYSQL_DATABASE=tinytinyrss
                        - MYSQL_USER=tinytinyrssuser
                        - MYSQL_PASSWORD=tinytinyrsspwd

# docker volumes to store data
volumes:
        myphpdata:
        mysqldata:

```

Here is the content of the nginx conf file (**conf_files/site.conf**)
```
server {
    listen 80;
    index index.php index.html;
    server_name localhost your-server-name;
    root /var/www/html/tt-rss;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}


```
