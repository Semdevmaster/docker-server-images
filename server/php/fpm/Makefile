include .env

#build php-fpm image
php-fpm-image-build:
	docker build \
    	-t php-fpm-docker-server:$(PHP_VERSION) \
    	--build-arg PHP_VERSION=$(PHP_VERSION) \
    	--build-arg SUPERCRONIC_VERSION=$(SUPERCRONIC_VERSION) \
    	--compress \
    	.
