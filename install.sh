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
  HOSTNAME="$(hostname -s)"
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
  info "Running home-manager switch for $HOSTNAME..."
  nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch --flake "$DOTFILES#$HOSTNAME"
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

# ── TPM ──────────────────────────────────────────────────────────────
if [[ ! -d "$DOTFILES/tmux/plugins/tpm" ]]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$DOTFILES/tmux/plugins/tpm"
fi

info "Done. Restart your shell."
