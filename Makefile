
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software # Foundation, either version 2 of the License, or
# (at your option) any later version.

DEPCMD  :=  $(shell if [ -f /usr/bin/dnf ]; then echo "dnf builddep"; else echo "yum-builddep"; fi)

SUBDIRS := Common Client documentation
ifdef WITH_SERVER
    SUBDIRS += Server
endif
ifdef WITH_LABCONTROLLER
    SUBDIRS += LabController
endif
ifdef WITH_INTTESTS
    SUBDIRS += IntegrationTests
endif

.PHONY: build
build: setup
	set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i build; done

install:
	set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i install; done

clean:
	set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i clean; done

.PHONY: check
check:
	set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i check; done

.PHONY: devel
devel: build
	set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i devel; done

.PHONY: setup
setup:
	sudo $(DEPCMD) -y beaker.spec
	git submodules init
	git submodules update
