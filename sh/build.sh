#!/bin/bash

echo "Build de tinytinyrss"
docker build -t gerault/docker-tinytinyrss-php5-fpm . --pull
