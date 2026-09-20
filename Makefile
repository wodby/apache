-include env_make

# Accept legacy build arguments during the image revision transition.
IMAGE_REVISION ?= $(STABILITY_TAG)

APACHE_VER ?= 2.4.68
APACHE_VER_MINOR ?= $(shell echo "${APACHE_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(APACHE_VER_MINOR)

PLATFORM ?= linux/amd64

REGISTRY ?= docker.io
REPO = $(REGISTRY)/wodby/apache
NAME = apache-$(APACHE_VER_MINOR)

ifneq ($(IMAGE_REVISION),)
    ifneq ($(TAG),latest)
         override TAG := $(TAG)-$(IMAGE_REVISION)
    endif
endif

.PHONY: build buildx-build buildx-build-amd64 buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		./

# --load  doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		--load \
		./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		./

buildx-push:
	docker buildx build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		./

test:
	cd ./tests/basic && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/php && IMAGE=$(REPO):$(TAG) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

compare-orig-configs:
	./check-configs.sh $(APACHE_VER)

release: build push

# Keep CI scans aligned with the version, variant and architecture built by make.
.PHONY: image-ref
image-ref:
	@printf '%s\n' '$(REPO):$(TAG)'

# Load each platform separately so the published image is the one Scout scanned.
.PHONY: buildx-load
buildx-load:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		--load \
		./
