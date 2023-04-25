ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"
# Verify packages list with sizes
# apk info 2>&1 | xargs -n1 -I{} apk info -s {} 2>&1 | grep -v "No such file" | xargs -n5

RUN apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data && apk del shadow

ARG TZ=Europe/Moscow
RUN apk add --no-cache alpine-conf && setup-timezone -z ${TZ} && apk del alpine-conf

#COPY ./install-php-extensions /usr/local/bin/
#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP Extensions (Uncomment the necessary)
ENV IPE_LZF_BETTERCOMPRESSION=1
RUN chmod +x /usr/local/bin/install-php-extensions; \
    install-php-extensions \
#    amqp \
#    apcu \
#    ast \
    bcmath \
#    blackfire \
#    bz2 \
#    calendar \
    csv \
#    dba \
#    decimal \
#    ds \
#    enchant \
#    ev \
#    event \
#    excimer \
    exif \
#    ffi \
    gd \
#    geospatial \
#    gettext \
#    gmagick \
#    gmp \
#    gnupg \
#    grpc \
#    http \
    igbinary \
    imagick \
    imap \
#    inotify \
    intl \
#    json_post \
#    ldap \
#    lzf \
#    mailparse \
#    maxminddb \
#    mcrypt \
#    memcache \
#    memcached \
#    mongodb \
#    msgpack \
#    mysqli \
#    oauth \
#    oci8 \
#    odbc \
    opcache \
#    opencensus \
#    openswoole \
    pcntl \
    pcov \
#    pdo_firebird \
    pdo_mysql \
#    pdo_oci \
#    pdo_odbc \
    pdo_pgsql \
#    pgsql \
#    pspell \
#    raphf \
#    rdkafka \
    redis \
#    seaslog \
#    shmop \
#    smbclient \
#    snmp \
#    snuffleupagus \
#    soap \
#    sockets \
#    solr \
#    spx \
#    ssh2 \
#    swoole \
#    sysvmsg \
#    sysvsem \
#    sysvshm \
#    tidy \
#    timezonedb \
#    uopz \
#    uploadprogress \
#    uuid \
    xdebug \
#    xhprof \
#    xlswriter \
#    xmldiff \
#    xmlrpc \
#    xsl \
#    yac \
#    yaml \
#    yar \
#    zephir_parser \
    zip \
#    zookeeper \
#    zstd \
;
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
# Create folders for additional ini files
RUN mkdir /usr/local/etc/php/disabled /usr/local/etc/php/extensions
