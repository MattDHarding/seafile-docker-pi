SERVER_VERSION ?= 7.0.5
BASE_IMAGE_VERSION ?= 18.04
PLATFORM ?= arm
TAG_ARCH ?= arm

main_base_image=phusion/baseimage:master
main_base_image_arch=$(main_base_image)-$(TAG_ARCH)

base_image_name=codecutteruk/seafile-base
base_image=$(base_image_name):$(BASE_IMAGE_VERSION)
base_image_arch=$(base_image)-$(TAG_ARCH)
base_image_squashed=$(base_image_arch)-squashed

pro_base_image=codecutteruk/seafile-pro-base:$(BASE_IMAGE_VERSION)-$(TAG_ARCH)
pro_base_image_squashed=codecutteruk/seafile-pro-base:$(BASE_IMAGE_VERSION)-$(TAG_ARCH)-squashed

server_image_name=codecutteruk/seafile
server_image=$(server_image_name):$(SERVER_VERSION)
server_image_arch=$(server_image)-$(TAG_ARCH)
server_image_squashed=$(server_image_name):$(SERVER_VERSION)-$(TAG_ARCH)-squashed

pro_server_image=codecutteruk/seafile-pro:$(SERVER_VERSION)-$(TAG_ARCH)
pro_server_image_squashed=codecutteruk/seafile-pro:$(SERVER_VERSION)-$(TAG_ARCH)-squashed

latest_pro_server_image=codecutteruk/seafile-pro:latest-$(TAG_ARCH)
latest_server_image=$(server_image_name):latest-$(TAG_ARCH)

all:
	@echo
	@echo Pleaes use '"make base"' or '"make server"' or '"make push"'.
	@echo

base:
	docker pull $(main_base_image_arch)
	docker-squash --tag $(main_base_image_arch)-latest $(main_base_image_arch)
	docker tag $(main_base_image_arch)-latest $(main_base_image_arch)
	cd base && docker build -t $(base_image_arch) --platform $(PLATFORM) .
	docker-squash --tag $(base_image_squashed) $(base_image_arch)
	docker tag $(base_image_squashed) $(base_image_arch)
	docker rmi `docker images --filter "dangling=true" -q --no-trunc`

base-multiarch:
	env NAME=$(base_image_name) VERSION=$(BASE_IMAGE_VERSION) ./build-multiarch.sh

server:
	cd seafile && cp -rf ../../scripts ./ && docker build -t $(server_image_arch) --build-arg BASE_IMAGE=$(base_image_arch) --build-arg SEAFILE_VERSION=$(SERVER_VERSION) --platform $(PLATFORM) .
	docker-squash --tag $(server_image_squashed) $(server_image_arch) --from-layer=$(base_image_arch)
	docker tag $(server_image_squashed) $(server_image_arch)
	docker tag $(server_image_arch) $(latest_server_image)
	docker rmi `docker images --filter "dangling=true" -q --no-trunc`

server-multiarch:
	env NAME=$(server_image_name) VERSION=$(SERVER_VERSION) ./build-multiarch.sh

pro-base:
	cd pro_base && docker build -t $(pro_base_image) --platform $(PLATFORM) .
	docker-squash --tag $(pro_base_image_squashed) $(pro_base_image)
	docker tag $(pro_base_image_squashed) $(pro_base_image)
	docker rmi `docker images --filter "dangling=true" -q --no-trunc`

pro-server:
	cd pro_seafile && cp -rf ../../scripts ./ && docker build -t $(pro_server_image) --platform $(PLATFORM) .
	docker-squash --tag $(pro_server_image_squashed) $(pro_server_image) --from-layer=$(pro_base_image)
	docker tag $(pro_server_image_squashed) $(pro_server_image)
	docker tag $(pro_server_image) $(latest_pro_server_image)
	docker rmi `docker images --filter "dangling=true" -q --no-trunc`

push-base:
	docker push $(base_image_arch)

push-pro-base:
	docker tag $(pro_base_image) ${host}/$(pro_base_image)
	docker push ${host}/$(pro_base_image)

push-server:
	docker push $(server_image_arch)
	docker push $(latest_server_image)

push-pro-server:
	docker tag $(pro_server_image) ${host}/$(pro_server_image)
	docker tag $(pro_server_image) ${host}/$(latest_pro_server_image)
	docker push ${host}/$(pro_server_image)
	docker push ${host}/$(latest_pro_server_image)

push: push-base push-server

.PHONY: base server push push-base push-server
