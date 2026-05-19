<img width="3440" height="1440" alt="Screenshot 2026-05-13 at 14 27 18" src="https://github.com/user-attachments/assets/2dfa87f4-b4bf-472c-885d-812a954dd6ed" />

# dotfiles

Cross-platform dotfiles managed with **Nix** + **Home Manager** + **nix-darwin**.
Supports macOS (Apple Silicon & Intel), NixOS, and standalone Linux (Home Manager — Rocky, Fedora, Ubuntu, WSL).

---

## Quick Start

### Bootstrap (first time)

**Requires**: `curl` (macOS: pre-installed; Linux: system package manager)

```bash
curl -fsSL https://raw.githubusercontent.com/leejunho-com/dotfiles/main/install.sh | bash
```

Nix and `git` are bootstrapped automatically — no manual prerequisites beyond `curl`.

`install.sh` handles everything automatically:
- Installs Nix via Determinate Systems installer (macOS / standalone Linux only — NixOS skips this)
- Renames conflicting system files (macOS)
- Bootstraps nix-darwin (macOS), runs nixos-rebuild (NixOS), or bootstraps home-manager (standalone Linux)
- Sets zsh as the default shell (standalone Linux)
- Sets up GPU drivers for WSLg (standalone Linux)
- Clones the private config repo

Platform and hostname are auto-detected — no manual editing required.

> Obviously the username is `leejunho` — update `flake.nix` (`user = "your-username"`) if yours somehow differs.

---

### Apply changes (day-to-day)

```bash
git add .
nix-switch   # rebuild current config (auto-detects platform/hostname)
```

> Nix flakes only read git-tracked files. Always `git add` before rebuilding.

### Update packages

```bash
nix-update   # flake update + build + nvd diff preview
nix-switch   # apply after reviewing diff
```

> `nix-update` previews changes without applying. Run `nix-switch` to apply — it reuses the existing build.

---

## Day-to-day Workflow

| Change | Command |
|--------|---------|
| Edit zshrc, ghostty, nvim, etc. | Just save — symlinked, no rebuild needed |
| Edit `tmux/tmux.conf` | `prefix+r` — sourced at runtime, no rebuild needed |
| Add / remove packages | Edit `home/common.nix` → rebuild |
| Change system settings (macOS) | Edit `modules/darwin/common.nix` → rebuild |
| Machine-specific changes | Edit `modules/darwin/<role>.nix` or `hosts/<name>/default.nix` → rebuild |

---

## Adding a New Machine

`install.sh` and `nix-switch.sh` auto-detect the hostname and fall back to a generic config if no machine-specific entry exists:

| Platform | Fallback key |
|----------|-------------|
| macOS Apple Silicon | `darwin` |
| macOS Intel | `darwin-x86` |
| NixOS x86_64 | `nixos` |
| NixOS aarch64 | `nixos-arm` |
| Standalone Linux | `linux` |

**No flake.nix edit needed** for generic machines — just run `install.sh`.

Only add a flake entry when the machine needs custom config (e.g. yabai, specific services):

**macOS** — under `darwinConfigurations`:
```nix
"your-hostname" = mkDarwin {
  system = "aarch64-darwin";       # or x86_64-darwin for Intel
  hostModules = [ ./hosts/your-hostname ];  # create hosts/your-hostname/default.nix
  homeModules = [ ./home/darwin/your-role.nix ];  # optional
};
```

**NixOS** — under `nixosConfigurations`:
```nix
"your-hostname" = mkNixos {
  system = "x86_64-linux";         # or aarch64-linux
  hostModules = [ ./hosts/your-hostname ];
  homeModules = [ ./home/linux/desktop.nix ];  # include for GUI machines
};
```

**Standalone Linux** — under `homeConfigurations`:
```nix
# CLI only
"your-hostname" = mkLinux { system = "x86_64-linux"; };

# GUI (WSL with WSLg, desktop distro)
"your-hostname" = mkLinux {
  system = "x86_64-linux";
  homeModules = [ ./home/linux/desktop.nix ];
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
├── nix-switch.sh                # Rebuild script — day-to-day (auto-detects platform/hostname)
├── nix-update.sh                # Update packages — nix flake update + build + nvd diff preview
│
├── modules/                     # Reusable config building blocks
│   ├── darwin/
│   │   ├── common.nix           # All Macs: nix.enable=false, skhd, system.defaults, homebrew casks, users
│   │   ├── workstation.nix      # Mac Studio role: yabai, sketchybar, jankyborders, transmission launchd
│   │   └── labtop.nix           # MacBook role: yabai, sketchybar, jankyborders
│   └── nixos/
│       ├── common.nix           # All NixOS: boot, networking, users, hyprland, greetd, flakes
│       └── parallels.nix        # Parallels VM: hardware.parallels.enable
│
├── hosts/                       # Per-machine thin wrappers (import modules)
│   ├── mac-studio/              # imports darwin/common + darwin/workstation
│   ├── macbook-pro/             # imports darwin/common + darwin/labtop
│   ├── macbook-neo/             # imports darwin/common + darwin/labtop
│   ├── macbook-pro-2018/        # imports darwin/common + darwin/labtop
│   └── nixos-vm/                # imports nixos/common + nixos/parallels + hostName
│
├── home/                        # Home Manager — user-level
│   ├── common.nix               # Packages + programs.zsh + symlinks (all machines)
│   ├── darwin/
│   │   ├── default.nix          # macOS-only packages + symlinks (all Macs)
│   │   └── workstation.nix      # Mac Studio: transmission_4
│   └── linux/
│       ├── default.nix          # Standalone Linux HM — CLI base (Fedora, WSL, etc.)
│       ├── nixos.nix            # NixOS home-manager — private + hyprland symlinks
│       └── desktop.nix          # GUI Linux: firefox, ghostty, mpv (WSL, desktop distros, NixOS)
│
├── hyprland/                    # → ~/.config/hypr (NixOS)
├── private/                     # Private nested repo (gitignored) → ~/.config/private
│
├── zsh/                         # sourced via programs.zsh.initContent
├── vim/                         # → ~/.vimrc
├── firefox/                     # chrome/userChrome.css, user.js (symlinked to profile via home.activation)
├── fzf/                         # → ~/.config/fzf
├── ghostty/                     # → ~/.config/ghostty (all platforms)
├── nvim/                        # → ~/.config/nvim
├── tmux/                        # tmux.conf sourced by programs.tmux (plugins managed by Nix)
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

> Most settings are managed via `system.defaults` in `modules/darwin/common.nix`.
> The following require manual configuration:

**Keyboard**
- Mission Control → Switch to Desktop {1–n}: `ctrl + {1–n}`
- Modifier Keys → Caps Lock: Control
- Dictation → Shortcut: Press mic

#### Firefox

Launch Firefox once after bootstrapping to create the profile, then run `nix-switch` again to apply `chrome/` and `user.js` symlinks automatically.

#### Homebrew

Homebrew is installed automatically by `install.sh`. Casks are managed declaratively via nix-darwin's `homebrew` module and synced on every `nix-switch`.

#### PATH Order

Nix takes precedence over Homebrew in `PATH`. `zshrc` appends Homebrew at the end so Nix-managed CLI tools are always preferred:

```
/etc/profiles/per-user/<user>/bin  ← Home Manager packages (Nix)
/run/current-system/sw/bin         ← nix-darwin system packages
/nix/var/nix/profiles/default/bin  ← Nix default profile
/usr/bin, /bin, ...                ← macOS system
/opt/homebrew/bin                  ← Homebrew (GUI app deps, fallback only)
```

nix-darwin sets Nix paths in `/etc/zshrc` before the user's `~/.zshrc` runs, so appending Homebrew in `zshrc` naturally puts it last.

> **Note**: Homebrew's installer automatically writes `eval "$(brew shellenv)"` to `~/.zprofile`, which would prepend Homebrew and override this order. `install.sh` removes that line automatically after installation.

#### Photoshop

Restore settings:

```bash
# backup
cp -r ~/Library/Preferences/"Adobe Photoshop 2025 Settings" /path/to/backup
# restore
sudo mv ./Adobe\ Photoshop\ 2025\ Settings ~/Library/Preferences/
```

#### Fonts

Core fonts are managed by Nix and installed automatically on `nix-switch`:

| Package | Use |
|---------|-----|
| `nerd-fonts.d2coding` | Monospace (terminal, editors) |
| `noto-fonts-cjk-sans` | CJK sans fallback (incl. Hangul Jamo for NFD filenames) |
| `noto-fonts-cjk-serif` | CJK serif |
| `pretendard-jp` | Primary sans-serif (Latin + Korean + Japanese superset) |
| `nerd-fonts.symbols-only` | Icon glyphs for sketchybar / mpv OSD |
| `sketchybar-app-font` | App icons in sketchybar (macOS only) |
| `fontconfig` | `fc-list` for looking up exact font family names |

**Font policy** — Firefox and mpv are configured to ignore page/system font selections and use the fonts declared here:

- **Sans-serif**: Pretendard JP (Latin, Korean, Japanese)
- **Serif**: Noto Serif CJK KR (Latin/Korean), Noto Serif CJK JP (Japanese)
- **Monospace**: D2CodingLigature Nerd Font
- **mpv OSD**: Pretendard JP Bold — icon glyphs rendered via ASS font tags (Symbols Nerd Font Mono)

Firefox `user.js` applies these via `font.name.*` prefs and disables page font override (`browser.display.use_document_fonts=0`). No manual `about:config` editing needed.

To look up the exact family name of any installed font (works on all platforms):

```bash
fc-list | grep -i <name>
```

On macOS, Nix fonts are copied to `~/Library/Fonts/HomeManager/` and recognized by CoreText immediately after `nix-switch`.

For any additional fonts not managed by Nix, restore from backup:

```bash
rsync -avh --exclude="HomeManager/" /path/to/backup/Fonts/ ~/Library/Fonts/
```

---

### NixOS

`modules/nixos/common.nix` imports `/etc/nixos/hardware-configuration.nix` (generated by the NixOS installer — not tracked in this repo). Run `nixos-generate-config` during installation as usual, then run `install.sh`.

---

### Linux

#### WSL Setup

Create `/etc/wsl.conf` before running `install.sh`:

```ini
[boot]
systemd = true

[network]
hostname = your-hostname
```

Then restart WSL from PowerShell:

```powershell
wsl --shutdown
```

`systemd = true` is required for the Nix daemon to run. The hostname here must match the key in `flake.nix` (or leave as-is to fall back to the generic `linux` config).

#### Package Manager Update

Update the system before running `install.sh`:

```bash
# Fedora
sudo dnf upgrade -y

# Ubuntu / Debian
sudo apt update && sudo apt upgrade -y
```

#### sudo Password (optional)

WSL defaults to passwordless sudo. To require a password like bare metal:

```bash
sudo passwd <your-username>
sudo rm /etc/sudoers.d/wsluser
```

#### Default Shell

`install.sh` automatically sets zsh (`~/.nix-profile/bin/zsh`) as the default shell. Restart the terminal after bootstrapping — the next session will load the full zsh config.

#### Firefox

Same as macOS — launch Firefox once after bootstrapping to create the profile, then run `nix-switch` again to apply `chrome/` and `user.js` symlinks.

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
modules/darwin/common.nix        ← system defaults, skhd, homebrew (all Macs)
modules/darwin/<role>.nix        ← role-specific services: workstation, labtop
hosts/<name>/default.nix         ← thin wrapper that imports the right modules
home/common.nix                  ← packages + zsh + symlinks (all machines)
home/darwin/default.nix          ← macOS-only packages + symlinks
home/darwin/<role>.nix           ← machine-specific home packages (optional)
```

For NixOS:
```
modules/nixos/common.nix         ← boot, networking, users, hyprland, greetd (all NixOS)
modules/nixos/parallels.nix      ← Parallels VM hardware support
hosts/<name>/default.nix         ← thin wrapper + hostName
home/linux/nixos.nix             ← NixOS home-manager (private + hyprland symlinks)
home/linux/desktop.nix           ← GUI packages: firefox, ghostty, mpv
```

Module files use a **role name** (e.g. `workstation.nix`, `labtop.nix`), not the hostname — multiple machines can share the same role.

**Dotfile management** — config files live in this repo and are symlinked into `~/.config/` via `mkOutOfStoreSymlink`. Edit files directly; changes reflect immediately without rebuilding.

**zsh plugins** — managed via `programs.zsh` in Home Manager (powerlevel10k, autosuggestions, syntaxHighlighting). The `zsh/zshrc` file is sourced via `initContent` — edit it directly, no rebuild needed.

---

## Roadmap

Known gaps and planned improvements:

- **Secret management** — `secrets/` is currently empty. Plan to adopt [agenix](https://github.com/ryantm/agenix) or [sops-nix](https://github.com/Mic92/sops-nix) for encrypted secrets inside the repo.
- **CI** — No automated validation yet. Plan to add a GitHub Actions workflow that runs `nix flake check` on every push, catching broken configs before they reach machines.
- **`install.sh` staging scope** — `git add -A` before rebuild is overly broad; will narrow to specific files to avoid accidentally staging sensitive files.
- **Linux keybindings** — keyd + sway planned for Linux key remapping (Super as Cmd equivalent). Currently on hold.
- **NixOS bare metal** — MacBook Pro 2018 (T2) target: t2linux kernel patches via `nixos-hardware`, to be added under `hosts/macbook-pro-2018-nixos/` when attempted.
