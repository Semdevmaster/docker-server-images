FROM alpine:3.16

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen; \
    rm -f /var/cache/apk/*

ARG TZ=Europe/Moscow
RUN apk add --no-cache alpine-conf && setup-timezone -z ${TZ} && apk del alpine-conf

COPY scripts/run.sh /scripts/run.sh

RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]
