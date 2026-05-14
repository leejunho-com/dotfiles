#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"
cd "$DOTFILES"

if [[ "$(uname)" == "Darwin" ]]; then
  HOST="$(scutil --get LocalHostName)"
  FALLBACK="$([[ "$(uname -m)" == "arm64" ]] && echo "darwin" || echo "darwin-x86")"
  nix eval "$DOTFILES#darwinConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  nix flake update
  sudo darwin-rebuild build --flake "$DOTFILES#$HOST"
  command -v nvd &>/dev/null && nvd diff /run/current-system ./result
else
  HOST="$(hostname -s)"
  nix eval "$DOTFILES#homeConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="linux"
  nix flake update
  home-manager build --flake "$DOTFILES#$HOST"
  command -v nvd &>/dev/null && nvd diff ~/.local/state/nix/profiles/home-manager ./result
fi
