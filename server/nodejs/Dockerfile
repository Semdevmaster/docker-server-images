ARG NODEJS_VERSION=16
FROM node:${NODEJS_VERSION}-alpine

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

ARG TZ=Europe/Moscow
RUN apk add --no-cache alpine-conf && setup-timezone -z ${TZ} && apk del alpine-conf

USER node

WORKDIR /var/www
