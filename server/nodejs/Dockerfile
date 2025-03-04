ARG NODEJS_VERSION=22
FROM node:${NODEJS_VERSION}-alpine3.21

LABEL maintainer="Semyon Kudryavtsev <arsentver@gmail.com>"

RUN apk add --no-cache curl tzdata && \
    npm install -g npm@latest && \
    npm cache clean --force && \
    rm -rf /tmp/* /var/cache/apk/*

USER node

WORKDIR /var/www
