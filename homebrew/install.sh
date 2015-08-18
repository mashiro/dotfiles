#!/bin/bash

brew update
brew upgrade

brew tap homebrew/services
brew tap caskroom/homebrew-cask
brew tap caskroom/homebrew-versions
brew install brew-cask

brew install zsh
brew install tmux
brew install emacs
brew install wget
brew install tree
brew install jq
brew install direnv
brew install imagemagick
brew install the_silver_searcher
brew install reattach-to-user-namespace
brew install readline

brew install lua luajit
brew install python3
brew install macvim --HEAD --override-system-vim --with-lua --with-luajit --with-python3

brew install rbenv
brew install ruby-build
brew install pyenv
brew install pyenv-virtualenv

brew cask install karabiner
brew cask install seil
brew cask install iterm2
brew cask install atom
brew cask install google-japanese-ime
brew cask install firefox-ja --appdir=/Applications
brew cask install google-chrome --appdir=/Applications
brew cask install google-chrome-canary --appdir=/Applications
brew cask install istat-menus
brew cask install gyazo
brew cask install dropbox
brew cask install vagrant
brew cask install virtualbox
brew cask install boot2docker

