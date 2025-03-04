include .env

#build franken php image
php-franken-image-build:
	docker build \
    	-t php-franken-docker-server:$(PHP_VERSION) \
    	--build-arg PHP_VERSION=$(PHP_VERSION) \
    	--build-arg SUPERCRONIC_VERSION=$(SUPERCRONIC_VERSION) \
    	--compress \
    	.
