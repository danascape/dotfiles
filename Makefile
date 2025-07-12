# Check if root
ifeq ($(shell id -u), 0)
	SUDO :=
else
	SUDO := sudo
endif

ifneq (,$(shell command -v apt 2>/dev/null))
	DISTRO := ubuntu
	INSTALL_CMD := apt install
else
    $(error "Distribution not supported")
endif

PHONY += help
help:
	@echo  'Base targets:'

.PHONY: $(PHONY)
