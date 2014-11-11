#!/bin/bash
ln -s .tmux.conf ~
ln -s .bashrc ~
ln -s .zshrc ~
ln -s .vimrc ~

# Install Vundle, assumes git is installed
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [ $3 == "ubuntu" ]; then
  sudo apt-get update;
  sudo apt-get install -y curl vim nodejs npm docker tmux
fi

if [ $3 == "centos" ]; then
  sudo yum update;
  # Nodejs startup script
  curl -sL https://rpm.nodesource.com/setup | bash -
  sudo yum install -y curl vim nodejs npm docker tmux
fi

if [ $3 == "mac" ]; then
  # Install homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install omz and version managers. Assumes curl is installed.
# I trust these sources. Do you?
if [ $2 == "true" ]; then
  # Install oh-my-zsh, assumes zsh is installed
  curl -L http://install.ohmyz.sh | sh

  # Install RVM
  curl -sSL https://get.rvm.io | bash -s stable

  # Install NVM
  curl https://raw.githubusercontent.com/creationix/nvm/v0.18.0/install.sh | bash
fi
