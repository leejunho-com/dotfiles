<img width="3840" alt="Screenshot 2025-05-04 at 00 08 58" src="https://github.com/user-attachments/assets/f8bec232-5731-48fc-8bbd-ea115d98ef4f" />

# dotfiles

Cross-platform dotfiles managed with **Nix** + **Home Manager** + **nix-darwin**.
Supports macOS (Apple Silicon & Intel) with Linux/WSL planned.

---

## Why Nix?

| | Homebrew | Nix |
|---|---|---|
| Reproducibility | Partial | Exact — same hash = same binary |
| Rollback | Manual | Built-in generations |
| Multi-machine | Brewfile sync | Declarative, version-locked |
| dotfile management | Manual symlinks | Home Manager |

Every package is installed into `/nix/store/<hash>-<name>/` — isolated, no conflicts, fully reproducible across machines.

---

## Core Concepts

**Flakes** — `flake.nix` + `flake.lock`. Think `package.json` + `package-lock.json`.
Pins every dependency to an exact version. Guarantees identical output on any machine.

**Home Manager** — Declarative user-level package and dotfile management.
Declare what you want in `home/common.nix`, run one command, done. Adding/removing packages is just editing a list.

**nix-darwin** — macOS system-level config as code.
Manages launchd services, system fonts, sudo rules, etc. The macOS equivalent of NixOS.

**Per-machine layering** — machines share a common base and add only what they need:

```
home/common.nix       ← packages + dotfile symlinks for every machine
home/darwin.nix       ← macOS-only additions (ghostty, yabai, sketchybar…)
hosts/common.nix      ← macOS system config shared by all Macs
hosts/mac-studio.nix  ← Mac Studio only (transmission, launchd service)
```

`flake.nix` wires up which modules each hostname gets. Adding a new machine = one new entry in `flake.nix`.

**Dotfile management** — config files live directly in this repo and are symlinked into `~/.config/` via `mkOutOfStoreSymlink`. Edit files in the repo directly; changes reflect immediately without rebuilding.

---

## Repository Structure

```
dotfiles/
├── flake.nix                    # Entry point — defines all machines
├── flake.lock                   # Pinned dependency versions (commit this)
│
├── home/                        # Home Manager — user-level
│   ├── common.nix               # Packages + symlinks for every machine
│   ├── darwin.nix               # macOS-only symlinks (ghostty, yabai…)
│   └── linux.nix                # Linux user config (planned)
│
├── hosts/                       # nix-darwin — system-level
│   ├── common.nix               # macOS system config shared by all Macs
│   ├── mac-studio.nix           # Mac Studio specific (transmission, launchd)
│   └── <hostname>.nix           # Add per-machine overrides here
│
├── secrets/                     # sops-encrypted secrets — safe to commit
│   └── private.yaml
│
├── env/
│   ├── public/                  # zshrc, p10k, vimrc, firefox
│   └── private/                 # private nested repo (gitignored)
│
├── ghostty/                     # → ~/.config/ghostty
├── nvim/                        # → ~/.config/nvim
├── tmux/                        # → ~/.config/tmux
├── yabai/                       # → ~/.config/yabai
├── skhd/                        # → ~/.config/skhd
├── sketchybar/                  # → ~/.config/sketchybar
├── karabiner/                   # → ~/.config/karabiner
├── yazi/                        # → ~/.config/yazi
└── mpv/                         # → ~/.config/mpv
```

---

## Installation

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

> Uses the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer) — enables flakes by default and supports clean uninstall.

Restart your terminal, or source the daemon manually:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Verify:

```bash
nix --version
```

---

### 2. Clone this repo

```bash
git clone https://github.com/leejunho-com/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
```

---

### 3. macOS

**Check your hostname** — this is the key used in `flake.nix`:

```bash
scutil --get LocalHostName
```

**Check your architecture** — needed when adding a new machine entry:

```bash
uname -m
# arm64  → aarch64-darwin  (Apple Silicon)
# x86_64 → x86_64-darwin   (Intel)
```

**First-time bootstrap** (installs nix-darwin):

```bash
cd ~/code/dotfiles
git add -A && git commit -m "init"   # flake requires committed files
nix run nix-darwin -- switch --flake ~/code/dotfiles#<hostname>
```

Replace `<hostname>` with the value from `scutil --get LocalHostName`.

**After that, apply changes with:**

```bash
darwin-rebuild switch --flake ~/code/dotfiles#<hostname>
```

> Nix flakes only read files tracked by git. Always commit (or at least `git add`) before rebuilding.

**Verify it worked:**

```bash
which bat
# Expected: /run/current-system/sw/bin/bat
```

---

### 4. Linux / WSL

> Work in progress. Home Manager standalone will be used.

```bash
nix run home-manager/master -- switch --flake ~/code/dotfiles#<hostname>
```

---

## Adding a New Machine

1. Get the hostname: `scutil --get LocalHostName` (macOS) or `hostname` (Linux)
2. Add an entry to `flake.nix`:

```nix
"your-hostname" = mkDarwin {
  system = "aarch64-darwin";  # or x86_64-darwin for Intel
  # extraModules = [ ./hosts/your-hostname.nix ];  # optional, if machine-specific config needed
};
```

3. Run:

```bash
darwin-rebuild switch --flake ~/code/dotfiles#your-hostname
```

---

## Applying Changes

```bash
# Full system rebuild (nix-darwin)
darwin-rebuild switch --flake ~/code/dotfiles#<hostname>

# User packages / dotfiles only (faster)
home-manager switch --flake ~/code/dotfiles#<hostname>
```

---

## Firefox

### about:config

| Key | Value |
|---|---|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` |
| `widget.macos.titlebar-blend-mode.behind-window` | `true` |
| `browser.theme.native-theme` | `true` |
