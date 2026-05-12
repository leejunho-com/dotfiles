#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"

if [[ "$(uname)" == "Darwin" ]]; then
  sudo darwin-rebuild switch --flake "$DOTFILES#$(scutil --get LocalHostName)"
  command -v yabai &>/dev/null && sudo yabai --load-sa
else
  home-manager switch --flake "$DOTFILES#$(hostname -s)"
fi
