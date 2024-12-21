#/bin/bash
set -e

dotfiles=$(realpath $(dirname $0))

# zsh
rm -f ~/.zshrc
ln -s $dotfiles/zsh/.zshrc ~/

mkdir -p ~/.config
rm -f ~/.config/kitty
ln -s $dotfiles/kitty ~/.config/
rm -f ~/.gitconfig
ln -s $dotfiles/git/.gitconfig ~/
if [ "$(uname -s)" = "Darwin" ] ; then
    mkdir -p ~/.config/fd
    rm -f ~/.aerospace.toml
    ln -s $dotfiles/osx/.aerospace.toml ~/
    rm -f ~/.config/karabiner
    ln -s $dotfiles/osx/karabiner ~/.config/
    rm -f ~/.config/fd/ignore
    ln -s $dotfiles/zsh/fdignore ~/.config/fd/ignore
    source $dotfiles/install.brew.sh
    source $dotfiles/install.nvim.sh
    source $dotfiles/install.dev.sh
    source $dotfiles/install.tmux.sh
    source $dotfiles/install.rust.sh
fi
