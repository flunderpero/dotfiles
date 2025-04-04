#/usr/bin/env bash
set -e

dotfiles=$(realpath $(dirname $0))

# zsh
rm -f ~/.zshrc
ln -s $dotfiles/zsh/.zshrc ~/

# bash
rm -f ~/.bash_profile
rm -f ~/.bashrc
rm -f ~/.bash_aliases
ln -s $dotfiles/bash/.bash_profile ~/
ln -s $dotfiles/bash/.bash_aliases ~/
ln -s $dotfiles/bash/.bashrc ~/

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
    ln -s $dotfiles/fdignore ~/.config/fd/ignore
    source $dotfiles/install.brew.sh
    source $dotfiles/install.nvim.sh
    source $dotfiles/install.dev.sh
    source $dotfiles/install.tmux.sh
    source $dotfiles/install.rust.sh
    # Adding /opt/homebrew/bin/bash to /etc/shells
    grep -qxF '/opt/homebrew/bin/bash' /etc/shells || echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells > /dev/null
    # Setting default shell
    dscl . -read ~/ UserShell | grep /opt/homebrew/bin/bash || chsh -s /opt/homebrew/bin/bash
fi
