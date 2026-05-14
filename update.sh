#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"

nix flake update "$DOTFILES"
