include .env

#build nginx image
nginx-image:
	docker build \
 	-t nginx-$(NGINX_VERSION):docker-server \
 	--build-arg NGINX_VERSION=$(NGINX_VERSION) \
 	--build-arg OPENSSL_VERSION=$(OPENSSL_VERSION) \
 	--build-arg PCRE_VERSION=$(PCRE_VERSION) \
 	--build-arg HEADERS_MORE_NGINX_MODULE=$(HEADERS_MORE_NGINX_MODULE) \
 	--build-arg TZ=$(NGINX_TIMEZONE) \
 	--compress \
 	--no-cache \
 	./server/nginx

#build php image
php-image:
	docker build \
	-t php-$(PHP_VERSION):docker-server \
	--build-arg PHP_VERSION=$(PHP_VERSION) \
	--build-arg TZ=$(PHP_TIMEZONE) \
	--compress \
	./server/php/$(PHP_VERSION)

php-cli-image:
	docker build \
	-t php-cli-$(PHP_VERSION):docker-server \
	--build-arg PHP_VERSION=$(PHP_VERSION) \
	--build-arg TZ=$(PHP_TIMEZONE) \
	--compress \
	--no-cache \
	./server/php/cli

#build mariadb image
mariadb-image:
	docker build \
 	-t mariadb-$(MYSQL_VERSION):docker-server \
 	--build-arg TZ=$(MYSQL_TIMEZONE) \
 	--compress \
	--no-cache \
 	./server/mysql

#build postgres image
postgres-image:
	docker build \
 	-t postgres-$(POSTGRES_VERSION):docker-server \
 	--build-arg TZ=$(POSTGRES_TIMEZONE) \
 	--compress \
	--no-cache \
 	./server/postgres

#build nodejs image
nodejs-image:
	docker build \
	-t nodejs-$(NODEJS_VERSION):docker-server \
	--build-arg NODEJS_VERSION=$(NODEJS_VERSION) \
	--build-arg TZ=$(NODEJS_TIMEZONE) \
	--compress \
	--no-cache \
	./server/nodejs

remove-old-images:
	docker rmi $$(docker images -qa -f 'dangling=true')
