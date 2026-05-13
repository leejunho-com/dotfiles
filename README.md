<img width="3440" height="1440" alt="Screenshot 2026-05-13 at 14 27 18" src="https://github.com/user-attachments/assets/2dfa87f4-b4bf-472c-885d-812a954dd6ed" />

# dotfiles

Cross-platform dotfiles managed with **Nix** + **Home Manager** + **nix-darwin**.
Supports macOS (Apple Silicon & Intel) and Linux/WSL (standalone Home Manager — Rocky, Fedora, Ubuntu, WSL).

---

## Quick Start

### Bootstrap (first time)

```bash
git clone https://github.com/leejunho-com/dotfiles.git ~/code/dotfiles
```

Edit `flake.nix` if your username differs from `leejunho`:

```nix
user = "your-username";
```

Then run:

```bash
bash ~/code/dotfiles/install.sh
```

`install.sh` handles everything automatically:
- Installs Nix (if not present)
- Clones the dotfiles repo
- Links `nix/nix.conf` → `~/.config/nix/nix.conf` (required before rebuild)
- Renames conflicting system files (macOS)
- Bootstraps nix-darwin (macOS) or runs home-manager switch (Linux)
- Clones the private config repo
- Installs TPM (tmux plugin manager)

Platform and hostname are auto-detected — no manual editing required.

### Apply changes (day-to-day)

```bash
git add .
load   # alias for load.sh — auto-detects platform and hostname
```

> Nix flakes only read git-tracked files. Always `git add` before rebuilding.

---

## Day-to-day Workflow

| Change | Command |
|--------|---------|
| Edit zshrc, ghostty, nvim, etc. | Just save — symlinked, no rebuild needed |
| Add / remove packages | Edit `home/common.nix` → rebuild |
| Change system settings | Edit `hosts/darwin/default.nix` → rebuild |
| Machine-specific changes | Edit `hosts/darwin/<role>.nix` → rebuild |

---

## Forking / Using with a Different Username

The system username is declared once in `flake.nix`:

```nix
user = "leejunho";
```

If your username differs, change this line before running `install.sh`. Everything else (Home Manager paths, nix-darwin user config, symlinks) derives from this single value.

---

## Adding a New Machine

`install.sh` and `load.sh` auto-detect the hostname and fall back to a generic config if no machine-specific entry exists:

| Platform | Fallback key |
|----------|-------------|
| macOS Apple Silicon | `darwin` |
| macOS Intel | `darwin-x86` |
| Linux | `linux` |

**No flake.nix edit needed** for generic machines — just run `install.sh`.

Only add a flake entry when the machine needs custom config (e.g. yabai, specific services):

**macOS** — under `darwinConfigurations`:
```nix
"your-hostname" = mkDarwin {
  system = "aarch64-darwin";  # or x86_64-darwin for Intel
  extraModules = [ ./hosts/darwin/your-role.nix ];  # optional
  homeModules  = [ ./home/darwin/your-role.nix ];   # optional
};
```

**Linux** — under `homeConfigurations`:
```nix
"your-hostname" = mkLinux {
  system = "x86_64-linux";
};
```

Run `install.sh` on the new machine:

```bash
git clone https://github.com/leejunho-com/dotfiles.git ~/code/dotfiles
bash ~/code/dotfiles/install.sh
```

---

## Repository Structure

```
dotfiles/
├── flake.nix                    # Entry point — defines all machines
├── flake.lock                   # Pinned dependency versions (commit this)
├── install.sh                   # Bootstrap script — first-time setup (auto-detects platform/hostname)
├── load.sh                      # Rebuild script — day-to-day (auto-detects platform/hostname)
│
├── home/                        # Home Manager — user-level
│   ├── common.nix               # Packages + programs.zsh + symlinks (all machines)
│   ├── darwin/
│   │   ├── default.nix          # macOS-only packages + symlinks (all Macs)
│   │   └── workstation.nix      # Mac Studio: transmission_4
│   └── linux/
│       └── default.nix          # Linux standalone HM (Rocky, Fedora, WSL Ubuntu, etc.)
│
├── hosts/                       # nix-darwin — system-level (darwin only)
│   ├── common.nix               # Platform-agnostic: nixpkgs.config, nix.enable = false (Determinate Nix)
│   └── darwin/
│       ├── default.nix          # All Macs: system.defaults, skhd, users
│       ├── workstation.nix      # Mac Studio: yabai, sketchybar, jankyborders, transmission launchd
│       └── labtop.nix           # MacBook Pro: yabai, sketchybar, jankyborders
│
├── private/                     # Private nested repo (gitignored) → ~/.config/private
├── nix/                         # nix.conf → ~/.config/nix/nix.conf (linked by install.sh)
│
├── zsh/                         # sourced via programs.zsh.initContent
├── vim/                         # → ~/.vimrc
├── firefox/                     # userChrome.css, userContent.css
├── fzf/                         # → ~/.config/fzf
├── ghostty/                     # → ~/.config/ghostty (all platforms)
├── nvim/                        # → ~/.config/nvim
├── tmux/                        # → ~/.config/tmux
├── yabai/                       # → ~/.config/yabai
├── skhd/                        # → ~/.config/skhd
├── sketchybar/                  # → ~/.config/sketchybar
├── karabiner/                   # → ~/.config/karabiner
├── yazi/                        # → ~/.config/yazi
├── mpv/                         # → ~/.config/mpv
├── pip/                         # → ~/.config/pip
├── yt-dlp/                      # → ~/.config/yt-dlp
├── btop/                        # → ~/.config/btop
├── git/                         # → ~/.config/git
├── htop/                        # → ~/.config/htop
├── incoming/                    # → ~/.config/incoming (HandBrake presets)
└── PureRef/                     # → ~/.config/PureRef
```

---

## Manual Setup

Steps that cannot be automated by Nix — run once after bootstrapping.

### Common

#### Firefox

Enable custom CSS in `about:config`:

| Key | Value |
|-----|-------|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` |
| `browser.download.alwaysOpenPanel` | `false` |

---

### macOS

#### System Integrity Protection

Boot into Recovery Mode, then:

```bash
csrutil disable
```

#### SSH

`/etc/ssh/sshd_config`:

```
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
```

#### System Preferences

> Most settings are managed via `system.defaults` in `hosts/darwin/default.nix`.
> The following require manual configuration:

**Keyboard**
- Mission Control → Switch to Desktop {1–n}: `ctrl + {1–n}`
- Modifier Keys → Caps Lock: Control
- Dictation → Shortcut: Press mic

#### Firefox

macOS-specific `about:config` keys (in addition to Common above):

| Key | Value |
|-----|-------|
| `widget.macos.titlebar-blend-mode.behind-window` | `true` |
| `browser.theme.native-theme` | `true` |

#### Homebrew

Nix manages CLI tools. Homebrew is kept for GUI apps only:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Photoshop

Restore settings:

```bash
# backup
cp -r ~/Library/Preferences/"Adobe Photoshop 2025 Settings" /path/to/backup
# restore
sudo mv ./Adobe\ Photoshop\ 2025\ Settings ~/Library/Preferences/
```

#### Fonts

Restore fonts:

```bash
rsync -avh /path/to/backup/Fonts/ ~/Library/Fonts/
```

---

### Linux

> TBD

---

## Why Nix?

| | Homebrew | Nix |
|--|----------|-----|
| Reproducibility | Partial | Exact — same hash = same binary |
| Rollback | Manual | Built-in generations |
| Multi-machine | Brewfile sync | Declarative, version-locked |
| dotfile management | Manual symlinks | Home Manager |

Every package is installed into `/nix/store/<hash>-<name>/` — isolated, no conflicts, fully reproducible across machines.

---

## Core Concepts

**Flakes** — `flake.nix` + `flake.lock`. Think `package.json` + `package-lock.json`. Pins every dependency to an exact version.

**Home Manager** — Declarative user-level package and dotfile management. Declare what you want in `home/common.nix`, rebuild once, done.

**nix-darwin** — macOS system-level config as code. Manages launchd services, system defaults, etc. The macOS equivalent of NixOS.

**Per-machine layering** — machines share a common base and add only what they need:

```
hosts/common.nix              ← nixpkgs.config, nix.enable = false (all platforms)
hosts/darwin/default.nix      ← system defaults, skhd (all Macs)
hosts/darwin/<role>.nix       ← machine-specific services (workstation, labtop, …)
home/common.nix               ← packages + zsh + symlinks (all machines)
home/darwin/default.nix       ← macOS-only packages + symlinks
home/darwin/<role>.nix        ← machine-specific home packages (optional)
```

Module files use a **role name** (e.g. `workstation.nix`, `labtop.nix`), not the hostname — multiple machines can share the same role.

**Dotfile management** — config files live in this repo and are symlinked into `~/.config/` via `mkOutOfStoreSymlink`. Edit files directly; changes reflect immediately without rebuilding.

**zsh plugins** — managed via `programs.zsh` in Home Manager (powerlevel10k, autosuggestions, syntaxHighlighting). The `zsh/zshrc` file is sourced via `initContent` — edit it directly, no rebuild needed.
