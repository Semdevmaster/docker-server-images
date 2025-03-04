include .env

#build nginx image
nginx-image-build:
	docker build \
 	-t nginx-docker-server:$(NGINX_VERSION) \
 	--build-arg NGINX_VERSION=$(NGINX_VERSION) \
 	--build-arg OPENSSL_VERSION=$(OPENSSL_VERSION) \
 	--build-arg PCRE_VERSION=$(PCRE_VERSION) \
 	--build-arg HEADERS_MORE_NGINX_MODULE=$(HEADERS_MORE_NGINX_MODULE) \
 	--compress \
 	.
