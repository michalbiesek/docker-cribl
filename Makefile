DOCKER_IMAGE_NAME ?= mbiesekcribl/cribl
DOCKER_IMAGE_TAG ?= 4.2.1

all: jemalloc-image mimalloc-image

jemalloc-image:
	docker build -t $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG) --file docker/jemalloc.Dockerfile .

mimalloc-image:
	docker build -t $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG) --file docker/mimalloc.Dockerfile .

push: all
	docker push $(DOCKER_IMAGE_NAME)-jemalloc:$(DOCKER_IMAGE_TAG)
	docker push $(DOCKER_IMAGE_NAME)-mimalloc:$(DOCKER_IMAGE_TAG)

help:
	@echo "Available targets:"
	@echo "  all  			 - Builds all Cribl Docker images"
	@echo "  push   		 - Pushes all Cribl Docker images"
	@echo "  jemalloc-image  - Builds the Cribl Docker image with jemalloc support"
	@echo "  mimalloc-image  - Builds the Cribl Docker image with mimalloc support"

.PHONY: all help jemalloc-image mimalloc-image push