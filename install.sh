#!/bin/bash
set -e

DOTFILES="$HOME/code/dotfiles"
PLATFORM="$(uname)"

info()  { echo "[INFO] $*"; }
warn()  { echo "[WARN] $*"; }

# ── Hostname detection ───────────────────────────────────────────────
if [[ "$PLATFORM" == "Darwin" ]]; then
  HOSTNAME="$(scutil --get LocalHostName)"
else
  HOSTNAME="$(uname -n)"
fi

info "Platform: $PLATFORM / Hostname: $HOSTNAME"

# ── Nix ─────────────────────────────────────────────────────────────
if ! command -v nix &>/dev/null; then
  info "Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# ── Dotfiles ─────────────────────────────────────────────────────────
if [[ ! -d "$DOTFILES" ]]; then
  info "Cloning dotfiles..."
  mkdir -p "$HOME/code"
  git clone https://github.com/leejunho-com/dotfiles.git "$DOTFILES"
fi

# ── Homebrew ─────────────────────────────────────────────────────────
if [[ "$PLATFORM" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ "$(uname -m)" == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  # Homebrew installer writes shellenv to ~/.zprofile — remove it since
  # zshrc handles PATH with Homebrew appended after Nix
  if grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
    sed -i'' '/brew shellenv/d' "$HOME/.zprofile"
    info "Removed brew shellenv from ~/.zprofile"
  fi
fi

# ── Darwin ───────────────────────────────────────────────────────────
if [[ "$PLATFORM" == "Darwin" ]]; then
  for f in /etc/bashrc /etc/zshrc; do
    [[ -f "$f" && ! -f "${f}.before-nix-darwin" ]] && sudo mv "$f" "${f}.before-nix-darwin" && warn "Renamed $f"
  done
  if [[ -f /etc/sudoers.d/yabai && ! -f /etc/sudoers.d/yabai.before-nix-darwin ]]; then
    sudo mv /etc/sudoers.d/yabai /etc/sudoers.d/yabai.before-nix-darwin
    warn "Renamed /etc/sudoers.d/yabai"
  fi

  cd "$DOTFILES" && git add -A
  FALLBACK="$([[ "$(uname -m)" == "arm64" ]] && echo "darwin" || echo "darwin-x86")"
  if ! nix --extra-experimental-features 'nix-command flakes' eval ".#darwinConfigurations" \
      --apply "x: builtins.hasAttr \"$HOSTNAME\" x" 2>/dev/null | grep -q true; then
    warn "No darwinConfigurations.$HOSTNAME found, falling back to '$FALLBACK'"
    HOSTNAME="$FALLBACK"
  fi
  if ! command -v darwin-rebuild &>/dev/null; then
    info "Bootstrapping nix-darwin for $HOSTNAME..."
    sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ".#$HOSTNAME"
  else
    info "Running darwin-rebuild switch for $HOSTNAME..."
    sudo darwin-rebuild switch --flake "$DOTFILES#$HOSTNAME"
  fi

# ── Linux ────────────────────────────────────────────────────────────
else
  cd "$DOTFILES" && git add -A
  if ! nix --extra-experimental-features 'nix-command flakes' eval ".#homeConfigurations" \
      --apply "x: builtins.hasAttr \"$HOSTNAME\" x" 2>/dev/null | grep -q true; then
    warn "No homeConfigurations.$HOSTNAME found, falling back to 'linux'"
    HOSTNAME="linux"
  fi
  info "Running home-manager switch for $HOSTNAME..."
  if command -v home-manager &>/dev/null; then
    home-manager switch --flake "$DOTFILES#$HOSTNAME"
  else
    info "Bootstrapping via nix run (first install)..."
    nix --extra-experimental-features 'nix-command flakes' run nixpkgs#home-manager -- \
      switch --flake "$DOTFILES#$HOSTNAME"
  fi
fi

# ── Non-NixOS GPU setup (Linux only) ────────────────────────────────
if [[ "$PLATFORM" != "Darwin" ]]; then
  GPU_SETUP=$(ls /nix/store/*-non-nixos-gpu*/bin/non-nixos-gpu-setup 2>/dev/null | head -1)
  [[ -n "$GPU_SETUP" ]] && sudo "$GPU_SETUP"
fi

# ── Default shell (Linux only) ───────────────────────────────────────
if [[ "$PLATFORM" != "Darwin" ]]; then
  ZSH_PATH="$HOME/.nix-profile/bin/zsh"
  if [[ -x "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
    grep -qF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
    sudo usermod -s "$ZSH_PATH" "$USER"
  fi
fi

# ── Private repo (gh installed via nix above) ────────────────────────
if [[ ! -d "$DOTFILES/private" ]]; then
  if ! gh auth status &>/dev/null; then
    info "GitHub authentication required for private repo..."
    gh auth login
  fi
  info "Cloning private repo..."
  gh repo clone leejunho-com/private "$DOTFILES/private"
fi

info "Done. Restart your shell."
