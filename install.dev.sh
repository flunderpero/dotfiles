#!/bin/bash

brew install nvm vips imagemagick graphicsmagick stern protobuf protobuf@3

brew tap homebrew/cask-fonts

echo "Enabling git commit signing..."
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa_pero_flunder_io_github.pub
git config --global commit.gpgsign true
