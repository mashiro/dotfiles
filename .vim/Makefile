
ifeq ($(OS), Windows_NT)
	MAKEFILE = make_msvc.mak
else

UNAME = $(shell uname)

ifeq ($(UNAME), Linux)
	MAKEFILE = make_gcc.mak
endif

ifeq ($(UNAME), Darwin)
	MAKEFILE = make_mac.mak
endif

endif

.PHONY: build
build:
	@vim -u .neobundle +NeoBundleInstall! +q +q
	@cd bundle/vimproc; make -f $(MAKEFILE)

