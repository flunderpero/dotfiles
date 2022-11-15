#!/bin/bash

dotfiles=$(realpath $(dirname $0))

rm -f ~/.tmux.conf
rm -f ~/.tmux
ln -s $dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s $dotfiles/tmux/.tmux ~/.tmux

brew install tmux

[ -d ~/.tmux/plugins/tpm ] || \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
