include .env

#build mariadb image
mariadb-image-build:
	docker build \
 	-t mariadb-docker-server:$(MARIADB_VERSION) \
 	--compress \
 	.
