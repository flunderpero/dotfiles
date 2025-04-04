#!/usr/bin/env bash

dotfiles=$(realpath $(dirname $0))

# Install Homebrew according to https://brew.sh.
if ! [ -x "$(command -v brew)" ]; then
    echo "Installing Homebrew ..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
export HOMEBREW_HOME="/usr/local"
[ -d "/opt/homebrew" ] && export HOMEBREW_HOME="/opt/homebrew"
eval "$($HOMEBREW_HOME/bin/brew shellenv)"

# Install essential brew packages.
brew install bat cask fd fzf git gnupg go graphicsmagick jq kustomize neovim nvm openjdk openssl \
    pyenv redis rg stern watch wget yarn \
    htop kitty keepassxc htop trash \
    bash-completion

# Use GNU commands where possible.
brew install autoconf bash binutils coreutils diffutils ed findutils flex gawk \
    gnu-indent gnu-sed gnu-tar gnu-which gpatch grep gzip less m4 make nano \
    screen wdiff wget zip xz
