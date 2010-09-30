#!/bin/sh

mksymlink() {
  local dir=`pwd`
  `ln -sf $dir/$1 $HOME/$1`
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

