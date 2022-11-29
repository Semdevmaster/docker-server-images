FROM alpine:3.17 AS build

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

ARG NGINX_VERSION=1.23.2
ARG OPENSSL_VERSION=3.0.7
ARG PCRE_VERSION=10.40
ARG HEADERS_MORE_NGINX_MODULE=0.34
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
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    --without-http_autoindex_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --add-module=../ngx_brotli \
    --add-module=../headers-more-nginx-module-${HEADERS_MORE_NGINX_MODULE} \
    && make -j$(nproc)

FROM alpine:3.17

ARG NGINX_VERSION=1.23.2
COPY --from=build /src/nginx-${NGINX_VERSION}/objs/nginx /usr/sbin/
COPY --from=build /src/nginx-${NGINX_VERSION}/conf/* /etc/nginx/
COPY --from=build /src/nginx-${NGINX_VERSION}/html/* /usr/share/nginx/html/

ARG TZ=Europe/Moscow
RUN apk add --no-cache alpine-conf && setup-timezone -z ${TZ} && apk del alpine-conf

RUN set -x \
    && apk -U upgrade \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -s /sbin/nologin -G nginx -g nginx nginx \
    && adduser -S -D -H -u 82 -s /bin/sh -G www-data -g www-data www-data \
    && apk add --no-cache \
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
    && rm -rf /src

COPY ./scripts/docker-entrypoint.sh /
COPY ./scripts/20-envsubst-on-templates.sh /docker-entrypoint.d

RUN chmod +x /docker-entrypoint.d/20-envsubst-on-templates.sh

ENTRYPOINT ["sh","/docker-entrypoint.sh"]

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
