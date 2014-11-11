#!/bin/bash
ln -s .tmux.conf ~
ln -s .zshrc ~
ln -s .vimrc ~

# Install Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
