include .env

#build postgres image
postgres-image-build:
	docker build \
 	-t postgres-docker-server:$(POSTGRES_VERSION) \
 	--compress \
 	.
