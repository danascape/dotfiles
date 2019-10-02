DIR = \
	$$HOME/.local/bin

FILES = \
	$$HOME/.bash_eternal_history

WORKAROUND_PACKAGES = \
	'^liblz4-.*' \
	'^liblzma.*' \
	'^lzma.*'

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

DEPS_DIR := .deps/$(DISTRO)

PHONY := all
all: build-env

PHONY += links
links:
	mkdir -p $(DIR)
	stow --verbose --restow --target=$$HOME .
	touch $(FILES)

PHONY += build-env
build-env: base build-tools dev embedded mail

define INSTALL_DEPS
	$(SUDO) $(INSTALL_CMD) $$(tr "\n" " " < $(DEPS_DIR)/$1)
endef

PHONY += base
base:
	$(call INSTALL_DEPS,base)
	$(SUDO) $(INSTALL_CMD) $(WORKAROUND_PACKAGES)

PHONY += build-tools
build-tools:
	$(call INSTALL_DEPS,build-tools)

PHONY += dev
dev:
	$(call INSTALL_DEPS,dev)

PHONY += embedded
embedded:
	$(call INSTALL_DEPS,embedded)

PHONY += mail
mail:
	$(call INSTALL_DEPS,mail)

PHONY += help
help:
	@echo  ''
	@echo  'Base targets:'
	@echo  '  all		    - Build base and links targets'
	@echo  '  links	            - Install the dotfiles links in $HOME using stow'
	@echo  '  build-env	    - Install all dependencies (.deps/**/*)'
	@echo  ''


PHONY += shellcheck
shellcheck:
	while read -r script; do shellcheck --exclude=SC1090,SC1091 $$script; done < files

.PHONY: $(PHONY)
