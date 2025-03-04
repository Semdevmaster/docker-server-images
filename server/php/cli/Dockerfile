ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli-alpine3.21

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

RUN apk -U upgrade && apk --no-cache add git shadow && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    usermod -u 1000 www-data && \
    groupmod -g 1000 www-data && \
    apk del shadow && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/www/html

RUN --mount=type=bind,from=ghcr.io/mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions \
    @composer

WORKDIR /var/www

USER php-cli
