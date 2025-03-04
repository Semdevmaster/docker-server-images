ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm-alpine3.21

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

RUN apk -U upgrade && \
    apk --no-cache add shadow tzdata supervisor && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    usermod -u 1000 www-data && \
    groupmod -g 1000 www-data && \
    apk del shadow && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/www/html

RUN --mount=type=bind,from=ghcr.io/mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions \
    @composer \
    opcache \
    gd \
    imagick \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    redis

ARG SUPERCRONIC_VERSION=v0.2.33
RUN arch="$(uname -m)" \
    && case "$arch" in \
    armhf) _cronic_fname='supercronic-linux-arm' ;; \
    aarch64) _cronic_fname='supercronic-linux-arm64' ;; \
    x86_64) _cronic_fname='supercronic-linux-amd64' ;; \
    x86) _cronic_fname='supercronic-linux-386' ;; \
    *) echo >&2 "error: unsupported architecture: $arch"; exit 1 ;; \
    esac \
    && wget -q "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/${_cronic_fname}" \
    -O /usr/bin/supercronic \
    && chmod +x /usr/bin/supercronic \
    && mkdir -p /etc/supercronic

WORKDIR /var/www
