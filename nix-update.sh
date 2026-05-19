#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"
cd "$DOTFILES"

if [[ "$(uname)" == "Darwin" ]]; then
  HOST="$(scutil --get LocalHostName)"
  FALLBACK="$([[ "$(uname -m)" == "arm64" ]] && echo "default" || echo "default-x86")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#darwinConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  nix --extra-experimental-features 'nix-command flakes' flake update
  sudo darwin-rebuild build --flake "$DOTFILES#$HOST"
  command -v nvd &>/dev/null && nvd diff /run/current-system ./result

elif [ -f /etc/NIXOS ]; then
  HOST="$(uname -n)"
  FALLBACK="$([[ "$(uname -m)" == "aarch64" ]] && echo "default-arm" || echo "default")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#nixosConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  nix --extra-experimental-features 'nix-command flakes' flake update
  sudo nixos-rebuild build --flake "$DOTFILES#$HOST" --impure
  command -v nvd &>/dev/null && nvd diff /run/current-system ./result

else
  HOST="$(uname -n)"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#homeConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="linux"
  nix --extra-experimental-features 'nix-command flakes' flake update
  home-manager build --flake "$DOTFILES#$HOST"
  command -v nvd &>/dev/null && nvd diff ~/.local/state/nix/profiles/home-manager ./result
fi
