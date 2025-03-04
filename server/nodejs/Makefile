include .env

#build nodejs image
nodejs-image-build:
	docker build \
	-t nodejs-docker-server:$(NODEJS_VERSION) \
	--build-arg NODEJS_VERSION=$(NODEJS_VERSION) \
	--compress \
	.
