# The program's build and tests: one Makefile, the same targets in every
# application begun from ernest-template. The four variables an application
# edits stand first; the rest is the same everywhere.
#
#   make          builds: the floor checked, lib/ filled, each dependency and
#                 then the program compiled
#   make test     the layout, the tests of every module, the documents, and
#                 test/ where it exists
#   make run      runs the program through its launcher
#   make lib      fills lib/: Ernest's own libraries linked, each dependency
#                 fetched and unpacked where it is not there
#   make doc      the documentation of every module, as CommonMark under build/
#   make format   lays every module out
#   make release  the archive, build/NAME-VERSION.tar.gz, tests first
#   make clean    removes what the build and make lib wrote

NAME        = epx
ERN_VERSION = 0.4
LIBS        =
DEPS        =

# The ern on PATH, or ERN=path/to/ern; where its libraries are, beside it as
# an installation and a checkout each lay them out.
ERN        ?= ern
ERN_DIR     = $(dir $(realpath $(shell command -v $(ERN))))
ERNEST_LIBS = $(firstword $(wildcard $(ERN_DIR)../lib/ernest/build/libs \
                                    $(ERN_DIR)../build/libs))

# Everything beyond the standard library stands under lib/<name>/build, so
# the load path is one glob, here and in the launcher.
LOAD_PATH   = $(addprefix --load-path ,$(shell ls -d lib/*/build 2>/dev/null))
DEP_DIRS    = $(addprefix lib/,$(notdir $(basename $(basename $(DEPS)))))
VERSION     = $(shell cat VERSION)

.PHONY: all version lib build test run doc format release clean

all: version lib build

# The program is written for one floor of ern (report §8.7); a development
# build of the floor passes.
version:
	@found=$$($(ERN) --version) && \
	case "$$found" in "ern $(ERN_VERSION)."*) ;; \
	    *) echo "ern $(ERN_VERSION) expected, $$found found"; exit 1 ;; esac

lib:
	@mkdir -p lib
	@for name in $(LIBS); do \
	    test -e lib/$$name/build && continue; \
	    test -n "$(ERNEST_LIBS)" || \
	        { echo "no libraries beside $(ERN): neither lib/ernest/build/libs nor build/libs"; exit 1; }; \
	    test -d "$(ERNEST_LIBS)/$$name" || \
	        { echo "Ernest has no library $$name under $(ERNEST_LIBS)"; exit 1; }; \
	    mkdir -p lib/$$name && ln -s "$(ERNEST_LIBS)/$$name" lib/$$name/build; \
	done
	@for url in $(DEPS); do \
	    dir=lib/$$(basename $$url .tar.gz); \
	    test -d $$dir && continue; \
	    echo "fetching $$url" && curl -fsSL "$$url" | tar -xzf - -C lib || exit 1; \
	done

# Each dependency is built by this ern from its source, in the order DEPS
# lists them, a dependency before what needs it; then the program.
build:
	@for dir in $(DEP_DIRS); do \
	    $(ERN) build --source-root $$dir/src --build-root $$dir/build $(LOAD_PATH) $$dir/src || exit 1; \
	done
	$(ERN) build --source-root src --build-root build $(LOAD_PATH) src

test: all
	$(ERN) format --check src tools $(wildcard test)
	$(ERN) test $(LOAD_PATH) build
	$(ERN) build --source-root tools --build-root tools/build tools
	$(ERN) test tools/build
	$(ERN) run tools/build/docs.erc
	@if test -d test; then \
	    $(ERN) build --source-root test --build-root test/build --load-path build $(LOAD_PATH) test && \
	    $(ERN) test --load-path build $(LOAD_PATH) test/build; \
	fi

run: all
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to run"; exit 1; }
	bin/$(NAME)

doc: all
	$(ERN) doc --source-root src --build-root build $(LOAD_PATH) src

format:
	$(ERN) format src tools $(wildcard test)

# The archive unpacks to NAME-VERSION/: the launcher where there is one, the
# source and the compiled modules, lib/ with each link copied through, the
# README and the license. One shape for an application and a library, so
# that any archive can be a dependency.
release: test
	@case "$$($(ERN) --version)" in *-dev) echo "a release is not made with a development build of ern"; exit 1 ;; esac
	rm -rf build/$(NAME)-$(VERSION) && mkdir -p build/$(NAME)-$(VERSION)
	cp -R src build/$(NAME)-$(VERSION)/src
	mkdir -p build/$(NAME)-$(VERSION)/build && \
	    find build -path build/$(NAME)-$(VERSION) -prune -o -name '*.erc' -print | \
	    cpio -pdm --quiet build/$(NAME)-$(VERSION)/
	test -d lib && cp -RL lib build/$(NAME)-$(VERSION)/lib || true
	test -x bin/$(NAME) && mkdir -p build/$(NAME)-$(VERSION)/bin && cp bin/$(NAME) build/$(NAME)-$(VERSION)/bin/ || true
	cp README.md LICENSE build/$(NAME)-$(VERSION)/
	tar -czf build/$(NAME)-$(VERSION).tar.gz -C build $(NAME)-$(VERSION)
	rm -rf build/$(NAME)-$(VERSION)

clean:
	rm -rf build tools/build test/build lib
