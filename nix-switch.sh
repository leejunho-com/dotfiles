#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"

if [[ "$(uname)" == "Darwin" ]]; then
  BEFORE=$(readlink -f /run/current-system)
  HOST="$(scutil --get LocalHostName)"
  FALLBACK="$([[ "$(uname -m)" == "arm64" ]] && echo "darwin" || echo "darwin-x86")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#darwinConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  sudo darwin-rebuild switch --flake "$DOTFILES#$HOST"
  command -v yabai &>/dev/null && sudo yabai --load-sa
  command -v nvd &>/dev/null && nvd diff "$BEFORE" /run/current-system
else
  BEFORE=$(readlink -f ~/.local/state/nix/profiles/home-manager)
  HOST="$(hostname -s)"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#homeConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="linux"
  home-manager switch --flake "$DOTFILES#$HOST" -b backup
  command -v nvd &>/dev/null && nvd diff "$BEFORE" ~/.local/state/nix/profiles/home-manager
fi
