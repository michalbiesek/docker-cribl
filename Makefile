DOCKER_IMAGE_NAME ?= mbiesekcribl/cribl
DOCKER_IMAGE_TAG ?= 4.2.1
BUILDER ?= cribl

all: builder jemalloc-image mimalloc-image

builder:
	@if ! docker buildx inspect --bootstrap $(BUILDER) >/dev/null 2>&1; then \
		docker buildx create --use --name $(BUILDER); \
	fi

jemalloc-image:
	docker buildx build --load --platform linux/amd64,linux/arm64 --file docker/jemalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG) .

mimalloc-image:
	docker buildx build --load --platform linux/amd64,linux/arm64 --file docker/mimalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG) .

push: all
	docker buildx build --push --platform linux/amd64,linux/arm64 --file docker/jemalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG) .
	docker buildx build --push --platform linux/amd64,linux/arm64 --file docker/mimalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG) .

help:
	@echo "Available targets:"
	@echo "  all  			 - Builds all Cribl Docker images"
	@echo "  push   		 - Pushes all Cribl Docker images"
	@echo "  jemalloc-image  - Builds the Cribl Docker image with jemalloc support"
	@echo "  mimalloc-image  - Builds the Cribl Docker image with mimalloc support"

.PHONY: all builder help jemalloc-image mimalloc-image push