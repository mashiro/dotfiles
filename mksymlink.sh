#!/bin/sh

mksymlink() {
  local dir=`pwd`
  `ln -si $dir/$1 $HOME`
}

mksymlink .gitconfig
mksymlink .gitignore.global
mksymlink .gvimrc
mksymlink .screenrc
mksymlink .vim
mksymlink .vimperator
mksymlink .vimperatorrc
mksymlink .vimrc
mksymlink .zshenv
mksymlink .zshrc
mksymlink .pythonstartup

