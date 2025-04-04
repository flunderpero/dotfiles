#!/usr/bin/env bash

dotfiles=$(realpath $(dirname $0))
rm -f ~/.config/nvim
ln -s $dotfiles/nvim ~/.config/

brew install nvim
