IMAGE 			:= liquibase-boot/exampledb
HASH			:= $$(git rev-parse --short HEAD)
VERSION 		:= 0.0.1
TAG_VERSION		:= ${IMAGE}:${VERSION}
TAG_HASH		:= ${IMAGE}:${HASH}
TAG_LATEST		:= ${IMAGE}:latest
DB_PORT			:= 5432
ROLLBACK		:= 0

.PHONY: deploy build apply clean check-env

deploy: build apply clean

build:

	docker build \
		-t ${TAG_VERSION} \
		-t ${TAG_HASH} \
		-t ${TAG_LATEST} \
		--build-arg VERSION=${VERSION} \
		.

apply: check-env

ifdef DB_CONTAINER
	docker run \
		--rm \
		--link ${DB_CONTAINER}:${DB_HOST} \
		-e "DB_USER=${DB_USER}" \
		-e "DB_PASSWORD=${DB_PASSWORD}" \
		-e "DB_HOST=${DB_HOST}" \
		-e "DB_PORT=${DB_PORT}" \
		-e "DB_NAME=${DB_NAME}" \
		-e "ROLLBACK=${ROLLBACK}" \
		-e "VERSION=${VERSION}" \
		${TAG_HASH}
endif
ifndef DB_CONTAINER
	docker run \
		--rm \
		-e "DB_USER=${DB_USER}" \
		-e "DB_PASSWORD=${DB_PASSWORD}" \
		-e "DB_HOST=${DB_HOST}" \
		-e "DB_PORT=${DB_PORT}" \
		-e "DB_NAME=${DB_NAME}" \
		-e "ROLLBACK=${ROLLBACK}" \
		-e "VERSION=${VERSION}" \
		${TAG_HASH}
endif

clean:
	docker rmi ${TAG_VERSION} -f
	docker rmi ${TAG_HASH} -f
	docker rmi ${TAG_LATEST} -f

check-env:
ifndef DB_USER
  $(error DB_USER is undefined)
endif
ifndef DB_PASSWORD
  $(error DB_PASSWORD is undefined)
endif
ifndef DB_HOST
  $(error DB_HOST is undefined)
endif
ifndef DB_NAME
  $(error DB_NAME is undefined)
endif