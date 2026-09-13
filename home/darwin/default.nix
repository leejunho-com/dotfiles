{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  # Finder opens these with nvim.
  nvimTypes = [
    # plain text and docs
    "txt" "md" "log" "conf" "ini"
    # config
    "json" "yaml" "yml" "toml" "nix" "cfg" "properties" "env"
    # scripts
    "sh" "bash" "zsh" "py" "lua" "applescript"
    # code
    "js" "css" "xml" "rs" "go" "c" "h" "cpp" "hpp" "rb" "php" "swift"
    # patches
    "diff" "patch"
    # subtitles and media metadata
    "smi" "srt" "ass" "ssa" "vtt" "lrc" "nfo" "plist"
    # systemd units
    "service" "timer"
    # data and playlists
    "csv" "tsv" "m3u" "m3u8"
  ];

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

  # Finder cannot hand a file to a terminal program, so a small AppleScript
  # bundle takes the open event and runs nvim in ghostty. osacompile sits outside
  # the nix build sandbox, so the bundle is built here instead. It must live in
  # ~/Applications -- LaunchServices ignores handlers under temp paths.
  home.activation.nvimOpenWrapper = config.lib.dag.entryAfter ["writeBoundary"] ''
    _app="$HOME/Applications/nvim.app"
    _stamp="$HOME/.cache/nvim-open.sha256"
    _src=$(mktemp)
    cat > "$_src" <<'APPLESCRIPT'
on run
launchNvim("")
end run

on open theFiles
set args to ""
repeat with f in theFiles
set args to args & " " & quoted form of POSIX path of f
end repeat
launchNvim(args)
end open

on launchNvim(args)
do shell script "__GHOSTTY__ -e __NVIM__" & args & " >/dev/null 2>&1 &"
end launchNvim
APPLESCRIPT
    sed -i "s#__GHOSTTY__#/Applications/Ghostty.app/Contents/MacOS/ghostty#; \
            s#__NVIM__#/etc/profiles/per-user/${user}/bin/nvim#" "$_src"

    # rebuild only when the script changed, so LaunchServices stays settled
    _want=$(sha256sum "$_src" | cut -d' ' -f1)
    if [[ "$_want" != "$(cat "$_stamp" 2>/dev/null || true)" || ! -d "$_app" ]]; then
      rm -rf "$_app"
      /usr/bin/osacompile -o "$_app" "$_src" || true
      /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string com.leejunho.nvim' \
        "$_app/Contents/Info.plist" || true
      mkdir -p "$(dirname "$_stamp")"
      echo "$_want" > "$_stamp"
    fi
    rm -f "$_src"

    _lsreg=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
    "$_lsreg" -f "$_app" || true

    for _ext in ${pkgs.lib.concatStringsSep " " nvimTypes}; do
      _cur=$(${pkgs.duti}/bin/duti -x "$_ext" 2>/dev/null | tail -1) || true
      if [[ "$_cur" != "com.leejunho.nvim" ]]; then
        ${pkgs.duti}/bin/duti -s com.leejunho.nvim "$_ext" all || true
      fi
    done
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
    ".config/private".source    = link "private";
  };
}
