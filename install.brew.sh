#!/bin/bash

dotfiles=$(realpath $(dirname $0))

# Install Homebrew according to https://brew.sh.
if ! [ -x "$(command -v brew)" ]; then
    echo "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
export HOMEBREW_HOME="/usr/local"
[ -d "/opt/homebrew" ] && export HOMEBREW_HOME="/opt/homebrew"
eval "$($HOMEBREW_HOME/bin/brew shellenv)"

# Install essential brew packages.
brew install bat cask fd fzf git gnupg go graphicsmagick jq kustomize neovim nvm openjdk openssl \
    pyenv redis rg stern watch wget yarn \
    htop kitty keepassxc htop trash 

# Use GNU commands where possible.
brew install coreutils gawk grep gnu-sed gnu-tar make findutils xz

# Let the GNU binaries take precedence over the OSX built-ins.
echo '# This file has been created by `install.brew.sh` ...' > $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/coreutils/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/findutils/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/gnu-tar/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/gnu-sed/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/grep/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
echo 'export PATH="$HOMEBREW_HOME/opt/make/libexec/gnubin:$PATH"' >> $dotfiles/zsh/.zsh_gnu
