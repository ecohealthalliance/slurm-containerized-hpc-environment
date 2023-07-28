SLURM_VERSION = 23.02
IMAGE = espirado/slurm.debs

DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: all build clean test

all: build

build: debs

debs:
	docker build -t $(IMAGE):$(SLURM_VERSION) .
	docker run --rm \
			-e SLURM_VERSION=$(SLURM_VERSION) \
			-v "$(DIR)/debs:/packages" $(IMAGE):$(SLURM_VERSION)

clean:
	@[ -z $(docker images -q $(IMAGE):$(SLURM_VERSION)) ] || docker rmi $(IMAGE):$(SLURM_VERSION)
	rm -rf debs
