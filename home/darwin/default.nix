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
  # __HM_SESS_VARS_SOURCED must be reset together: set-environment hard-resets
  # PATH in pane shells, so hm-session-vars.sh (sessionPath: ~/.local/bin etc.)
  # must re-source too — resetting only the nix-darwin guard drops HM paths.
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
        --set __NIX_DARWIN_SET_ENVIRONMENT_DONE "" \
        --set __HM_SESS_VARS_SOURCED "" \
        --set __HM_ZSH_SESS_VARS_SOURCED ""
    '';

  # darwin-only dotfiles → ~/.config/ symlinks
  home.file = {
    ".config/sketchybar".source = link "sketchybar";
    ".config/skhd".source       = link "skhd";
    ".config/yabai".source      = link "yabai";
    ".config/karabiner".source  = link "karabiner";
    ".config/private".source   = link "private";
  };
}
