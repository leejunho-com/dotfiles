#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"

if [[ "$(uname)" == "Darwin" ]]; then
  BEFORE=$(readlink -f /run/current-system)
  HOST="$(scutil --get LocalHostName)"
  FALLBACK="$([[ "$(uname -m)" == "arm64" ]] && echo "default" || echo "default-x86")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#darwinConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  sudo darwin-rebuild switch --flake "$DOTFILES#$HOST"
  command -v yabai &>/dev/null && sudo yabai --load-sa
  command -v nvd &>/dev/null && nvd diff "$BEFORE" /run/current-system

elif [ -f /etc/NIXOS ]; then
  BEFORE=$(readlink -f /run/current-system)
  HOST="$(uname -n)"
  FALLBACK="$([[ "$(uname -m)" == "aarch64" ]] && echo "default-arm" || echo "default")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#nixosConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  sudo nixos-rebuild switch --flake "$DOTFILES#$HOST" --impure
  command -v nvd &>/dev/null && nvd diff "$BEFORE" /run/current-system

else
  BEFORE=$(readlink -f ~/.local/state/nix/profiles/home-manager)
  HOST="$(uname -n)"
  FALLBACK="$([[ "$(uname -m)" == "aarch64" ]] && echo "default-arm" || echo "default")"
  nix --extra-experimental-features 'nix-command flakes' eval "$DOTFILES#homeConfigurations" \
    --apply "x: builtins.hasAttr \"$HOST\" x" 2>/dev/null | grep -q true || HOST="$FALLBACK"
  home-manager switch --flake "$DOTFILES#$HOST"
  command -v nvd &>/dev/null && nvd diff "$BEFORE" ~/.local/state/nix/profiles/home-manager
fi
