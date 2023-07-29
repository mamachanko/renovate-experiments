.DEFAULT_GOAL := help
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# renovate: datasource=docker depName=renovate packageName=ghcr.io/renovatebot/renovate
RENOVATE_VERSION ?= 40.26.1
RENOVATE_REPOSITORY ?= mamachanko/renovate-experiments
RENOVATE_LOG_LEVEL ?= DEBUG

.PHONY: help
help: ## Describe all make targets (default)
	@./Makefile_help.awk $(MAKEFILE_LIST)

.PHONY: renovate-in-docker
renovate-in-docker:
ifndef GITHUB_COM_TOKEN
	$(error GITHUB_COM_TOKEN must be set)
endif
	docker run \
	  --rm \
	  --tty \
	  --interactive \
	  --workdir /src \
	  --env LOG_LEVEL=$(RENOVATE_LOG_LEVEL) \
	  --volume /root/.docker=$(PWD)/.dockerconfig \
	  ghcr.io/renovatebot/renovate:$(RENOVATE_VERSION) \
	  renovate \
	    --platform github \
	    --token $${GITHUB_COM_TOKEN} \
	    --recreate-when always \
	    $(RENOVATE_REPOSITORY)
