#!/usr/bin/env bash

dotfiles=$(realpath $(dirname $0))

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
