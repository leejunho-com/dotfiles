#!/bin/bash
# Run this once on a fresh WSL instance, before install.sh.
# Usage: bash wsl-setup.sh <hostname>
# Example: bash wsl-setup.sh wsl-fedora
set -e

info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*"; }

# ── Hostname ─────────────────────────────────────────────────────────
HOSTNAME="${1:-}"
if [[ -z "$HOSTNAME" ]]; then
  read -rp "Hostname for this WSL instance: " HOSTNAME
fi

# ── wsl.conf ─────────────────────────────────────────────────────────
info "Writing /etc/wsl.conf (hostname=$HOSTNAME, systemd=true)..."
sudo tee /etc/wsl.conf > /dev/null << EOF
[boot]
systemd = true

[network]
hostname = $HOSTNAME
EOF

# ── sudoers NOPASSWD ─────────────────────────────────────────────────
NOPASSWD_FILE=""
for f in /etc/sudoers.d/*; do
  grep -q "NOPASSWD" "$f" 2>/dev/null && NOPASSWD_FILE="$f" && break
done

if [[ -n "$NOPASSWD_FILE" ]]; then
  warn "Found NOPASSWD rule: $NOPASSWD_FILE"
  read -rp "Remove it (require sudo password like bare metal)? [y/N] " REPLY
  if [[ "${REPLY,,}" == "y" ]]; then
    warn "Set your password first:"
    sudo passwd "$(whoami)"
    sudo rm "$NOPASSWD_FILE"
    info "Removed $NOPASSWD_FILE — sudo will now require a password"
  fi
fi

# ── Done ─────────────────────────────────────────────────────────────
info "Done. Run from PowerShell: wsl --shutdown"
info "Then start WSL again and run: bash install.sh"
