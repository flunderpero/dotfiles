#!/bin/bash

dotfiles=$(realpath $(dirname $0))
rm -f ~/.config/nvim
ln -s $dotfiles/nvim ~/.config/

brew install nvim rg

# Bootstrap packer.nvim and install all plugins.
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
