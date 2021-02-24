-include env_make

APACHE_VER ?= 2.4.46
APACHE_VER_MINOR ?= $(shell echo "${APACHE_VER}" | grep -oE '^[0-9]+\.[0-9]+')
BASE_IMAGE_TAG = $(APACHE_VER)-alpine

TAG ?= $(APACHE_VER_MINOR)

PLATFORM ?= linux/amd64

REPO = wodby/apache
NAME = apache-$(APACHE_VER_MINOR)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
         override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		./

buildx-push:
	docker buildx build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg APACHE_VER=$(APACHE_VER) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
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
