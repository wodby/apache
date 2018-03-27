-include env_make

APACHE_VER ?= 2.4.33
APACHE_VER_MINOR ?= $(shell echo "${APACHE_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(APACHE_VER_MINOR)

REPO = wodby/apache
NAME = apache-$(APACHE_VER_MINOR)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
         override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) --build-arg APACHE_VER=$(APACHE_VER) ./

test:
	cd ./test && IMAGE=$(REPO):$(TAG) ./run

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
	./compare_orig_configs $(APACHE_VER)

release: build push
