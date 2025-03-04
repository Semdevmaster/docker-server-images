FROM alpine:3.21 AS build

RUN set -x \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

RUN apk -U upgrade \
    && apk add --no-cache --virtual \
    .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    gd-dev \
    geoip-dev \
    libedit-dev \
    findutils \
    git

ARG NGINX_VERSION=1.27.4
ARG OPENSSL_VERSION=3.4.1
ARG PCRE_VERSION=10.45
ARG HEADERS_MORE_NGINX_MODULE=0.38
RUN set -ex \
    && mkdir /src \
    && cd /src \
    && wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE_VERSION}/pcre2-${PCRE_VERSION}.tar.gz \
    && wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${HEADERS_MORE_NGINX_MODULE}.tar.gz -O headers-more-nginx-module.tar.gz\
    && git clone --recurse-submodules "https://github.com/google/ngx_brotli.git" \
    && tar zxf nginx-${NGINX_VERSION}.tar.gz \
    && tar zxf openssl-${OPENSSL_VERSION}.tar.gz \
    && tar zxf pcre2-${PCRE_VERSION}.tar.gz \
    && tar zxf headers-more-nginx-module.tar.gz \
    && rm -rf *.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --user=nginx \
    --group=nginx \
    --with-debug \
    --with-compat \
    --with-pcre=../pcre2-${PCRE_VERSION} \
    --with-pcre-jit \
    --with-threads \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_slice_module \
    --with-openssl=../openssl-${OPENSSL_VERSION} \
    --with-openssl-opt=enable-ktls \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-stream \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
    --with-cc-opt='-Os -fstack-clash-protection -Wformat -Werror=format-security -fno-plt -g' \
    --with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs' \
    --without-http_autoindex_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --add-module=../ngx_brotli \
    --add-module=../headers-more-nginx-module-${HEADERS_MORE_NGINX_MODULE} \
    && make -j$(nproc)

FROM alpine:3.21

ARG NGINX_VERSION=1.27.4
COPY --from=build --link /src/nginx-${NGINX_VERSION}/objs/nginx /usr/sbin/
COPY --from=build --link /src/nginx-${NGINX_VERSION}/conf/* /etc/nginx/
COPY --from=build --link /src/nginx-${NGINX_VERSION}/html/* /usr/share/nginx/html/

RUN set -x \
    && apk -U upgrade \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -s /sbin/nologin -G nginx -g nginx nginx \
    && adduser -S -D -H -u 82 -s /bin/sh -G www-data -g www-data www-data \
    && apk add --no-cache \
    tzdata \
    curl \
    ca-certificates \
    gettext \
    && mkdir -p \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/log/nginx \
    /docker-entrypoint.d \
    /etc/nginx/conf.d \
    && rm -rf /src /var/cache/apk/*

COPY --chmod=755 --link ./scripts/docker-entrypoint.sh /
COPY --chmod=755 --link ./scripts/15-local-resolvers.envsh /docker-entrypoint.d
COPY --chmod=755 --link ./scripts/20-envsubst-on-templates.sh /docker-entrypoint.d
COPY --chmod=755 --link ./scripts/30-tune-worker-processes.sh /docker-entrypoint.d

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
