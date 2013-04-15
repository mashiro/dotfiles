
EXCLUDES = . .. .git .gitignore .gitmodules
DOT_FILES = $(filter-out $(EXCLUDES),$(wildcard .*))
DEPEND_DIRS = .screen/log .virtualenvs

INSTALL_DIR = $(HOME)
CURRENT_DIR = $(shell pwd)

INSTALLED_DOT_FILES = $(addprefix $(INSTALL_DIR)/,$(DOT_FILES))
INSTALLED_DEPEND_DIRS = $(addprefix $(INSTALL_DIR)/,$(DEPEND_DIRS))

LN = ln -sf
MKDIR = mkdir -p


.PHONY: all
all: build


.PHONY: ls
ls:
	@echo "DOT FILES:" $(DOT_FILES)
	@echo "DEPEND DIRS:" $(DEPEND_DIRS)


.PHONY: build
build:
	git pull origin master
	git submodule update --init
	git submodule foreach 'git checkout master; git pull origin master'
	cd .vim; $(MAKE)

.PHONY: install install-dot-files install-depend-dirs
install: install-dot-files install-depend-dirs
install-dot-files: $(INSTALLED_DOT_FILES)
install-depend-dirs: $(INSTALLED_DEPEND_DIRS)

$(INSTALLED_DOT_FILES):
	$(LN) $(CURRENT_DIR)/$(notdir $@) $@

$(INSTALLED_DEPEND_DIRS):
	$(MKDIR) $@


.PHONY: uninstall uninstall-dot-files
uninstall: uninstall-dot-files
uninstall-dot-files:
	$(RM) $(foreach filename, $(DOT_FILES), $(INSTALL_DIR)/$(filename))

