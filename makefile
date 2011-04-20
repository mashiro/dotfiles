DOTFILES =\
	.gitconfig \
	.gitignore.global \
	.zshrc \
	.zshenv \
	.screenrc \
	.vim \
	.vimrc \
	.gvimrc \
	.vimperator \
	.vimperatorrc \
	.pythonstartup \
	.irbrc \

DOTFILES_LOCAL =\
	.vimrc.local \
	.zshrc.local \
	.zshenv.local \


SRCDIR = $(shell pwd)
DESTDIR = $(HOME)

LN = ln -sni
TOUCH = touch
MKDIR = mkdir -p


all: update

update:
	git pull origin master
	git submodule update --init
	git submodule foreach 'git checkout master; git pull origin master'

install .PHONY: $(DOTFILES) $(DOTFILES_LOCAL)
	$(MKDIR) $(DESTDIR)/.screen/log
	$(MKDIR) $(DESTDIR)/.virtualenvs
	git submodule update --init
	git submodule foreach 'git checkout master'

$(DOTFILES):
	$(LN) $(SRCDIR)/$@ $(DESTDIR)/$@

$(DOTFILES_LOCAL):
	$(TOUCH) $(DESTDIR)/$@


uninstall .PHONY: clean-dotfiles clean-dotfiles-local

uninstall-dotfiles:
	$(RM) $(foreach filename, $(DOTFILES), $(DESTDIR)/$(filename))

uninstall-dotfiles-local:
	$(RM) $(foreach filename, $(DOTFILES_LOCAL), $(DESTDIR)/$(filename))

