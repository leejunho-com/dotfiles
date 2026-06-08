{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [ darwin.trash wireguard-go sketchybar-app-font mpv ];

  # Wrap tmux to reset shell-sourcing guards before server starts.
  # Mirrors nix-darwin's programs.tmux module approach: without this,
  # __NIX_DARWIN_SET_ENVIRONMENT_DONE is inherited by the tmux server and
  # /etc/zshenv skips set-environment in new panes, causing stale NIX_PROFILES.
  programs.tmux.package = pkgs.runCommand pkgs.tmux.name
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      source $stdenv/setup
      mkdir -p $out/bin
      makeWrapper ${pkgs.tmux}/bin/tmux $out/bin/tmux \
        --set __ETC_BASHRC_SOURCED "" \
        --set __ETC_ZPROFILE_SOURCED "" \
        --set __ETC_ZSHENV_SOURCED "" \
        --set __ETC_ZSHRC_SOURCED "" \
        --set __NIX_DARWIN_SET_ENVIRONMENT_DONE ""
    '';

  # Compile alt-monitor on nix-switch if source is newer than binary
  home.activation.buildAltMonitor = config.lib.dag.entryAfter ["writeBoundary"] ''
    _src="${dotfiles}/scripts/alt-monitor.swift"
    _bin="$HOME/.local/bin/alt-monitor"
    mkdir -p "$HOME/.local/bin" "$HOME/.local/log"
    if [[ ! -f "$_bin" ]] || [[ "$_src" -nt "$_bin" ]]; then
      echo "Building alt-monitor..."
      /usr/bin/swiftc -O "$_src" -o "$_bin"
    fi
  '';

  # launchd user agent — starts alt-monitor at login
  launchd.agents.alt-monitor = {
    enable = true;
    config = {
      Label = "com.leejunho.alt-monitor";
      ProgramArguments = [ "${config.home.homeDirectory}/.local/bin/alt-monitor" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "${config.home.homeDirectory}/.local/log/alt-monitor.log";
    };
  };

  # darwin-only dotfiles → ~/.config/ symlinks
  home.file = {
    ".config/sketchybar".source = link "sketchybar";
    ".config/skhd".source       = link "skhd";
    ".config/yabai".source      = link "yabai";
    ".config/karabiner".source  = link "karabiner";
    ".config/private".source   = link "private";
  };
}
