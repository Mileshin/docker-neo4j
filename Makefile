SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif

.RECIPEPREFIX = >

all: dev/builds-okay
.PHONY: all

test: $(TAG)
> image=test/$$RANDOM; docker build --tag=$$image $(TAG); docker run --name test --rm $$image
.PHONY: test

stop-test:
> docker stop test
.PHONY: stop-test

clean::
> rm -rf dev
.PHONY: clean

%/Dockerfile: Dockerfile.template Makefile lookup
> @mkdir -p $*
> export VERSION=$*; sed "s|%%VERSION%%|$$(./lookup version)|; s|%%DOWNLOAD_SHA%%|$$(./lookup sha)|; s|%%DOWNLOAD_ROOT%%|$$(./lookup root)|; s|%%INJECT_TARBALL%%|$$(./lookup inject)|" $< >$@

%/neo4j.sh: neo4j.sh Makefile
> @mkdir -p $*
> cp $< $@

dev/builds-okay: dev/Dockerfile dev/neo4j.sh dev/neo4j-package.tar.gz
> @mkdir -p dev
> docker build dev
> touch $@

dev/neo4j-package.tar.gz: $(DEV_ROOT)/neo4j-community-*-unix.tar.gz
> @mkdir -p dev
> cp $< $@

all: 2.3.0-M03
2.3.0-M03: 2.3.0-M03/Dockerfile 2.3.0-M03/neo4j.sh
.PHONY: 2.3.0-M03
clean::
> rm -rf 2.3.0-M03

all: 2.3.0-M02
2.3.0-M02: 2.3.0-M02/Dockerfile 2.3.0-M02/neo4j.sh
.PHONY: 2.3.0-M02
clean::
> rm -rf 2.3.0-M02

all: 2.2.5
2.2.5: 2.2.5/Dockerfile 2.2.5/neo4j.sh
.PHONY: 2.2.5
clean::
> rm -rf 2.2.5

all: 2.2.4
2.2.4: 2.2.4/Dockerfile 2.2.4/neo4j.sh
.PHONY: 2.2.4
clean::
> rm -rf 2.2.4

all: 2.2.3
2.2.3: 2.2.3/Dockerfile 2.2.3/neo4j.sh
.PHONY: 2.2.3
clean::
> rm -rf 2.2.3

all: 2.2.2
2.2.2: 2.2.2/Dockerfile 2.2.2/neo4j.sh
.PHONY: 2.2.2
clean::
> rm -rf 2.2.2