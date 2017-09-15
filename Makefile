
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software # Foundation, either version 2 of the License, or
# (at your option) any later version.

INITSYS :=  $(shell if [ -f /usr/bin/systemctl ]; then echo "systemd"; else echo "sysvinit"; fi)
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

.PHONY: build install delean check devel deps submods

build: deps
	set -e; for i in $(SUBDIRS); do $(MAKE) INITSYS=$(INITSYS) -C $$i build; done

install:
	set -e; for i in $(SUBDIRS); do $(MAKE) INITSYS=$(INITSYS) -C $$i install; done

clean:
	set -e; for i in $(SUBDIRS); do $(MAKE) INITSYS=$(INITSYS) -C $$i clean; done

check:
	set -e; for i in $(SUBDIRS); do $(MAKE) INITSYS=$(INITSYS) -C $$i check; done

devel: build
	set -e; for i in $(SUBDIRS); do $(MAKE) INITSYS=$(INITSYS) -C $$i devel; done

deps:
	sudo $(DEPCMD) -y beaker.spec

submods:
	git submodules init
	git submodules update
