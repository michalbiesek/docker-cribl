DOCKER_IMAGE_NAME ?= mbiesekcribl/cribl
DOCKER_IMAGE_TAG ?= 4.2.1
BUILDER ?= cribl

all: builder jemalloc-image mimalloc-image

builder:
	docker buildx create --use --name $(BUILDER) --driver docker-container --bootstrap

jemalloc-image:
	docker buildx build --platform linux/amd64,linux/arm64/v8 --file docker/jemalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG) .

mimalloc-image:
	docker buildx build --platform linux/amd64,linux/arm64/v8 --file docker/mimalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG) .

push:
	docker buildx build --progress=plain --push --platform linux/amd64,linux/arm64/v8 --file docker/jemalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG) --output type=registry .
	docker buildx build --progress=plain --push --platform linux/amd64,linux/arm64/v8 --file docker/mimalloc.Dockerfile --tag $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG) --output type=registry .

help:
	@echo "Available targets:"
	@echo "  all  			 - Builds all Cribl Docker images"
	@echo "  push   		 - Pushes all Cribl Docker images"
	@echo "  jemalloc-image  - Builds the Cribl Docker image with jemalloc support"
	@echo "  mimalloc-image  - Builds the Cribl Docker image with mimalloc support"

.PHONY: all builder help jemalloc-image mimalloc-image push