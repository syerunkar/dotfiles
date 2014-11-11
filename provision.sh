#!/bin/bash
# ./provision.sh <OPERATING_SYSTEM>
# use as such:
# ./provision.sh mac
ln -s .tmux.conf ~
ln -s .bashrc ~
ln -s .zshrc ~
ln -s .vimrc ~
ln -s .gitconfig ~

# Install Vundle, assumes git is installed
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [ $3 == "ubuntu" ]; then
  sudo apt-get update;
  sudo apt-get install -y curl vim nodejs npm docker tmux zsh
fi

if [ $3 == "centos" ]; then
  sudo yum update;
  # Nodejs startup script
  curl -sL https://rpm.nodesource.com/setup | bash -
  sudo yum install -y curl vim nodejs npm docker tmux zsh
fi

if [ $3 == "mac" ]; then
  # Install homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install tmux zsh node npm pyenv
fi

# Install omz and version managers. Assumes curl is installed.
# I trust these sources. Do you?
if [ $3 != "" ]; then
  # Install oh-my-zsh, assumes zsh is installed
  curl -L http://install.ohmyz.sh | sh

  # Install RVM
  curl -sSL https://get.rvm.io | bash -s stable

  # Install NVM
  curl https://raw.githubusercontent.com/creationix/nvm/v0.18.0/install.sh | bash

  # Install PyEnv
  curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi
