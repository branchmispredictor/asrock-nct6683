include Kbuild

KDIR ?= /lib/modules/`uname -r`/build

ifneq (,$(wildcard .git/*))
	PACKAGE_VERSION := $(shell git describe --long --always)
else
	ifneq ("", "$(wildcard VERSION)")
		PACKAGE_VERSION := $(shell cat VERSION)
	else
		PACKAGE_VERSION := unknown
	endif
endif


.PHONY: all install modules modules_install clean dkms dkms_clean dkms_configure
all: modules

modules modules_install clean:
	@$(MAKE) -C $(KDIR) M=$$PWD $@


SOURCES := $(patsubst %.o,%.c,$(obj-m))

checkpatch:
	$(KDIR)/scripts/checkpatch.pl $(SOURCES)

# DKMS
DRIVER_NAME = asrock-nct6683
BUILD_MODULE_NAME = nct6683

dkms_configure:
	@sed -e 's/@PACKAGE_VERSION@/$(PACKAGE_VERSION)/' \
	     -e 's/@PACKAGE_NAME@/$(DRIVER_NAME)/' \
	     -e 's/@BUILT_MODULE_NAME@/$(BUILD_MODULE_NAME)/' dkms.conf.am > dkms.conf
	@echo "$(PACKAGE_VERSION)" >VERSION
dkms: dkms_configure
	@dkms add $(CURDIR)
	@dkms build -m $(DRIVER_NAME) -v $(PACKAGE_VERSION)
	@dkms install --force -m $(DRIVER_NAME) -v $(PACKAGE_VERSION)
	@modprobe $(BUILD_MODULE_NAME)

dkms_clean:
	-@rmmod $(BUILD_MODULE_NAME);
	-@dkms remove -m $(DRIVER_NAME) -v $(PACKAGE_VERSION)
	-@rm dkms.conf VERSION
