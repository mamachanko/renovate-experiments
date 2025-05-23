# ----------------
# This is the Makefile. It exposes all the project's affordances.
#
# If something is automated, you will find it here.
# If something should be automated, put it here.
#
# The convention for Make target names generally is "<noun>(-<verb>)"-ish,
# e.g. packaging, cluster-create or git-ensure-clean.
#
# Learn more about Makefiles:
#  * Quick reference: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html#Quick-Reference
#  * The Makefile tutorial: https://makefiletutorial.com/
#  * Make documentation: https://www.gnu.org/software/make/manual/html_node/index.html#Top
#  * Functions, variables and directives: https://www.gnu.org/software/make/manual/html_node/Name-Index.html
#
# Happy making!
# ----------------

.DEFAULT_GOAL := help

# Use Bash as the shell.
# See https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := bash

# Run each Make recipe as one single shell session.
# See https://www.gnu.org/software/make/manual/html_node/One-Shell.html#One-Shell
.ONESHELL:

# Run safe shell commands.
# See https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
.SHELLFLAGS := -eu -o pipefail -c

# Remove targets if their recipes fail. This avoids corrupted or improperly built targets.
# See https://www.gnu.org/software/make/manual/html_node/Errors.html#Errors
.DELETE_ON_ERROR:
# Caveat: this only works for regular files and not for directories.
# See http://savannah.gnu.org/bugs/?func=detailitem&item_id=16372

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# renovate: datasource=docker depName=renovate packageName=ghcr.io/renovatebot/renovate
RENOVATE_VERSION ?= 40.26.0
RENOVATE_REPOSITORY ?= mamachanko/renovate-experiments
RENOVATE_LOG_LEVEL ?= DEBUG

.PHONY: help
help: ## Describe all make targets (default)
	@./Makefile_help.awk $(MAKEFILE_LIST)

.PHONY: build
build: build-upstream build-downstream

.PHONY: build-upstream
build-upstream:
	cd a-go-upstream/
	go mod tidy
	go run .

.PHONY: build-downstream
build-downstream:
	cd b-go-downstream/
	go mod tidy
	go run .

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
	  --volume /root/.docker=$(PWD)/dockerconfig \
	  ghcr.io/renovatebot/renovate:$(RENOVATE_VERSION) \
	  renovate \
	    --platform github \
	    --token $${GITHUB_COM_TOKEN} \
	    $(RENOVATE_REPOSITORY)
