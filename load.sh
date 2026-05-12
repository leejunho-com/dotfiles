#!/bin/bash
set -e

if [[ "$(uname)" == "Darwin" ]]; then
  sudo darwin-rebuild switch --flake ~/code/dotfiles#"$(scutil --get LocalHostName)"
else
  home-manager switch --flake ~/code/dotfiles#"$(hostname -s)"
fi
