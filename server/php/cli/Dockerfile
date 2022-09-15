ARG PHP_VERSION=8.1
FROM php:${PHP_VERSION}-cli-alpine

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

RUN apk -U upgrade \
    && apk add --no-cache --virtual git \
    && mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini \
    && addgroup -g 1000 php-cli \
    && adduser -u 1000 -G php-cli -s /bin/sh -D php-cli

ARG TZ=Europe/Moscow
RUN apk add --no-cache alpine-conf && setup-timezone -z ${TZ} && apk del alpine-conf

COPY ./install-php-extensions /usr/local/bin/

ENV IPE_LZF_BETTERCOMPRESSION=1
RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions pdo_mysql pdo_pgsql zip

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www

USER php-cli
