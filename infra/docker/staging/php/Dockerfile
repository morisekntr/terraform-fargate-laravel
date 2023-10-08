FROM node:16.13-alpine as node

WORKDIR /build
COPY ./laravel .
COPY ./laravel/.env.staging .env
ARG VITE_PUSHER_APP_KEY
ARG VITE_PUSHER_APP_CLUSTER
RUN npm install
RUN VITE_PUSHER_APP_KEY=${VITE_PUSHER_APP_KEY} VITE_PUSHER_APP_CLUSTER=${VITE_PUSHER_APP_CLUSTER} npm run build

FROM php:8.1-fpm-bullseye
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

ENV TZ='Asia/Tokyo'\
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
  apt-get -y install git libicu-dev libonig-dev libzip-dev unzip locales default-mysql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  locale-gen en_US.UTF-8 && \
  localedef -f UTF-8 -i en_US en_US.UTF-8 && \
  mkdir /var/run/php-fpm && \
  docker-php-ext-install intl pdo_mysql zip bcmath opcache && \
  composer config -g process-timeout 3600 && \
  composer config -g repos.packagist composer https://packagist.org

COPY ./infra/docker/staging/php/php-fpm.d/zzz-www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY ./infra/docker/staging/php/php.ini /usr/local/etc/php/php.ini

COPY --chown=www-data:www-data ./laravel /work/laravel
COPY --chown=www-data:www-data ./laravel/.env.staging /work/laravel/.env
COPY --from=node --chown=www-data:www-data /build/public/build/manifest.json /work/laravel/public/build/manifest.json

WORKDIR /work/laravel

RUN chmod 777 -R storage && \
  chmod 777 -R bootstrap/cache && \
  composer install --optimize-autoloader --no-dev && \
  composer require predis/predis && \
  php artisan config:cache && \
  php artisan route:cache && \
  php artisan view:cache
