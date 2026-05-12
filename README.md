<img width="3840" alt="Screenshot 2025-05-04 at 00 08 58" src="https://github.com/user-attachments/assets/f8bec232-5731-48fc-8bbd-ea115d98ef4f" />

# dotfiles

Cross-platform dotfiles managed with **Nix** + **Home Manager** + **nix-darwin**.
Supports macOS (Apple Silicon & Intel) and Linux/WSL (standalone Home Manager — Rocky, Fedora, Ubuntu, WSL).

---

## Quick Start

### Bootstrap (first time)

```bash
git clone https://github.com/leejunho-com/dotfiles.git ~/code/dotfiles
bash ~/code/dotfiles/install.sh
```

`install.sh` handles everything automatically:
- Installs Nix (if not present)
- Clones the private config repo
- Renames conflicting system files (macOS)
- Bootstraps nix-darwin (macOS) or runs home-manager switch (Linux)
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
| Machine-specific changes | Edit `hosts/darwin/<hostname>.nix` → rebuild |

---

## Adding a New Machine

1. Add an entry to `flake.nix`:

**macOS** — under `darwinConfigurations`:
```nix
"your-hostname" = mkDarwin {
  system = "aarch64-darwin";  # or x86_64-darwin for Intel
  # extraModules = [ ./hosts/darwin/your-hostname.nix ];  # optional
  # homeModules  = [ ./home/darwin/your-hostname.nix ];   # optional
};
```

**Linux** — under `homeConfigurations`:
```nix
"your-hostname" = mkLinux {
  system = "x86_64-linux";
};
```

2. Run `install.sh` on the new machine — hostname is auto-detected:

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
│   │   └── mac-studio.nix       # Mac Studio: transmission_4
│   └── linux/
│       └── default.nix          # Linux standalone HM (Rocky, Fedora, WSL Ubuntu, etc.)
│
├── hosts/                       # nix-darwin — system-level (darwin only)
│   ├── common.nix               # Platform-agnostic: nix.settings, nixpkgs.config
│   └── darwin/
│       ├── default.nix          # All Macs: system.defaults, skhd, users
│       └── mac-studio.nix       # Mac Studio: yabai, sketchybar, jankyborders, transmission launchd
│
├── private/                     # Private nested repo (gitignored) → ~/.config/private
│
├── zsh/                         # sourced via programs.zsh.initContent
├── vim/                         # → ~/.vimrc
├── firefox/                     # userChrome.css, userContent.css
├── fzf/                         # → ~/.config/fzf
├── ghostty/                     # → ~/.config/ghostty
├── nvim/                        # → ~/.config/nvim
├── tmux/                        # → ~/.config/tmux
├── yabai/                       # → ~/.config/yabai
├── skhd/                        # → ~/.config/skhd
├── sketchybar/                  # → ~/.config/sketchybar
├── karabiner/                   # → ~/.config/karabiner
├── yazi/                        # → ~/.config/yazi
├── mpv/                         # → ~/.config/mpv
├── pip/                         # → ~/.config/pip
└── yt-dlp/                      # → ~/.config/yt-dlp
```

---

## Firefox

Enable custom CSS in `about:config`:

| Key | Value |
|-----|-------|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` |
| `widget.macos.titlebar-blend-mode.behind-window` | `true` |
| `browser.theme.native-theme` | `true` |

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
hosts/common.nix           ← nix settings (all platforms)
hosts/darwin/default.nix   ← system defaults, skhd (all Macs)
hosts/darwin/<hostname>.nix ← machine-specific services
home/common.nix            ← packages + zsh + symlinks (all machines)
home/darwin/default.nix    ← macOS-only packages + symlinks
home/darwin/<hostname>.nix ← machine-specific home config
```

**Dotfile management** — config files live in this repo and are symlinked into `~/.config/` via `mkOutOfStoreSymlink`. Edit files directly; changes reflect immediately without rebuilding.

**zsh plugins** — managed via `programs.zsh` in Home Manager (powerlevel10k, autosuggestions, syntaxHighlighting). The `zsh/zshrc` file is sourced via `initContent` — edit it directly, no rebuild needed.
