#!/usr/bin/env bash

brew install nvm vips imagemagick graphicsmagick stern protobuf protobuf@3

brew install font-fira-code

echo "Enabling git commit signing..."
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa_pero_flunder_io_github.pub
git config --global commit.gpgsign true
git config --global alias.co checkout
git config --global alias.cm commit
git config --global alias.st status
git config --global alias.br branch
