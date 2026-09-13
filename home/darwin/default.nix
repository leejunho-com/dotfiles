{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  # Finder opens these with mpv. Matches config/yazi/yazi.toml.
  mpvTypes = [
    # video
    "3gp" "avi" "m2ts" "m2v" "m4v" "mkv" "mov" "mp4" "mpeg" "mpg" "mts" "ts" "webm" "wmv"
    # audio
    "aac" "ac3" "aif" "aiff" "flac" "m4a" "mka" "mp3" "ogg" "opus" "wav" "wma"
    # image
    "avif" "bmp" "gif" "jpeg" "jpg" "png" "tif" "tiff" "webp"
  ];
in
{
  home.packages = with pkgs; [ darwin.trash wireguard-go sketchybar-app-font mpv duti ];

  # inherited guards make new panes skip set-environment and hm-session-vars,
  # leaving stale NIX_PROFILES and a PATH without sessionPath
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

  # LaunchServices can pin the handler to an mpv store path that a later GC
  # deletes, so re-register the stable copy first. Set only what differs --
  # macOS prompts the user on every change.
  home.activation.mpvDefaultApps = config.lib.dag.entryAfter ["writeBoundary"] ''
    _lsreg=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
    "$_lsreg" -f "$HOME/Applications/Home Manager Apps/mpv.app" || true

    for _ext in ${pkgs.lib.concatStringsSep " " mpvTypes}; do
      # bundle id is the last line duti -x prints
      _cur=$(${pkgs.duti}/bin/duti -x "$_ext" 2>/dev/null | tail -1) || true
      if [[ "$_cur" != "io.mpv" ]]; then
        ${pkgs.duti}/bin/duti -s io.mpv "$_ext" all || true
      fi
    done
  '';

  # darwin-only dotfiles → ~/.config/ symlinks
  home.file = {
    ".config/sketchybar".source = link "config/sketchybar";
    ".config/skhd".source       = link "config/skhd";
    ".config/yabai".source      = link "config/yabai";
    ".config/karabiner".source  = link "config/karabiner";
    ".config/private".source   = link "private";
  };
}
