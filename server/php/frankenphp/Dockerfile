ARG PHP_VERSION=8.4
FROM dunglas/frankenphp:php${PHP_VERSION}-bookworm

ENV SERVER_NAME=:80

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        unzip \
        supervisor; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    rm -rf /var/lib/apt/lists/*

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
    && mkdir -p /etc/supercronic \
    && echo "*/1 * * * * php /app/artisan schedule:run >> /dev/null 2>&1" > /etc/supercronic/laravel

ARG USER=www-data
RUN usermod -u 1000 ${USER} && groupmod -g 1000 ${USER}
RUN chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy

USER ${USER}

#CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
#CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]
