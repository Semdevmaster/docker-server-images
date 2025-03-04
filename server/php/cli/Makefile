include .env

#build php-cli image
php-cli-image-build:
	docker build \
    	-t php-cli-docker-server:$(PHP_VERSION) \
    	--build-arg PHP_VERSION=$(PHP_VERSION) \
    	--compress \
    	.
