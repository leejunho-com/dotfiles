{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = user;
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${user}" else "/home/${user}";

  # bin/ is on PATH directly — new scripts need only chmod +x, no nix change
  home.sessionPath = [ "$HOME/.local/bin" "${dotfiles}/bin" ];

  home.packages = with pkgs; [
    # gnu
    coreutils findutils util-linux gnused gawk gnugrep gnutar diffutils

    # essential
    bat eza fd fzf ripgrep tree jq wget zoxide unar p7zip rsync mc yazi w3m htop btop duf
    iperf3 nmap wireguard-tools convmv magic-wormhole tealdeer poppler fontconfig

    # media
    ffmpeg-full ffmpegthumbnailer imagemagick mediainfo yt-dlp viu chafa resvg exiftool

    # ricing
    fastfetch figlet lolcat cmatrix asciinema asciinema-agg ascii-image-converter

    # dev
    git nodejs neovim delta lazygit gh nvd tree-sitter nil

    # fonts
    nerd-fonts.d2coding noto-fonts-cjk-sans noto-fonts-cjk-serif pretendard-jp nerd-fonts.symbols-only
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles = { comment = "fg=#F37021"; };
    };
    plugins = [{
      name = "powerlevel10k";
      src  = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }];
    initContent = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      source ${dotfiles}/config/zsh/zshrc
    '';
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = prefix-highlight;
        extraConfig = ''
        set -g @prefix_highlight_empty_prompt '  #H  #S '
        set -g @prefix_highlight_prefix_prompt ' #H  #S'
        set -g @prefix_highlight_fg '#f37021' # default is 'colour231'
        set -g @prefix_highlight_bg 'default'  # default is 'colour04'
        set -g @prefix_highlight_show_copy_mode 'on'
        set -g @prefix_highlight_copy_prompt ' VISUAL'
        set -g @prefix_highlight_copy_mode_attr 'fg=default,bg=#800080' # default is 'fg=default,bg=yellow'
        set -g @prefix_highlight_show_sync_mode 'on'
        set -g @prefix_highlight_sync_prompt ' SYNC'
        set -g @prefix_highlight_sync_mode_attr 'fg=black,bg=green' # default is 'fg=default,bg=yellow'
        set -g status-left "#{prefix_highlight}"
        set -g status-left-length 50
        set -g status-right ""
        set -g status-right-length 50
        '';
      }
    ];
    extraConfig = "source-file ${config.home.homeDirectory}/code/dotfiles/config/tmux/tmux.conf";
  };

  home.activation.nixExperimentalFeatures = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/nix"
    grep -qxF "extra-experimental-features = nix-command flakes" "$HOME/.config/nix/nix.conf" 2>/dev/null || \
      echo "extra-experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
  '';

  home.activation.firefoxChrome = config.lib.dag.entryAfter ["writeBoundary"] (''
    if ${pkgs.lib.boolToString pkgs.stdenv.hostPlatform.isDarwin}; then
      _ff_roots=("$HOME/Library/Application Support/Firefox")
    else
      # Firefox 147+: XDG path (~/.config/mozilla) for new installs; legacy (~/.mozilla) for existing
      _ff_roots=("$HOME/.config/mozilla/firefox" "$HOME/.mozilla/firefox")
    fi
    profile_dir=""
    for _root in "''${_ff_roots[@]}"; do
      # installs.ini names the profile this install opens; its paths are relative to the ini
      _rel=$(sed -n 's/^Default=//p' "$_root/installs.ini" 2>/dev/null | head -1) || true
      case "$_rel" in
        "") continue ;;
        /*) profile_dir="$_rel" ;;
        *)  profile_dir="$_root/$_rel" ;;
      esac
      if [[ -d "$profile_dir" ]]; then break; fi
      profile_dir=""
    done
    if [[ -z "$profile_dir" ]]; then
      echo "Firefox profile not found, skipping"
    else
      for _f in chrome user.js; do
        _dst="$profile_dir/$_f"
        # replace any symlink, even a live one aimed elsewhere; real files stay
        if [[ -L "$_dst" || ! -e "$_dst" ]]; then
          ln -sfn "${dotfiles}/config/firefox/$_f" "$_dst"
        else
          echo "Firefox: $_dst is not a symlink, leaving it alone"
        fi
      done
    fi
  '');

  # dotfiles → ~/ and ~/.config/ symlinks
  home.file = {
    ".p10k.zsh".source      = link "config/zsh/p10k.zsh";
    ".vimrc".source         = link "config/vim/vimrc";
    ".config/ghostty".source = link "config/ghostty";
    ".config/nvim".source   = link "config/nvim";
    ".config/yazi".source   = link "config/yazi";
    ".config/mpv".source    = link "config/mpv";
    ".config/pip".source    = link "config/pip";
    ".config/fzf".source    = link "config/fzf";
    ".config/yt-dlp".source  = link "config/yt-dlp";
    ".config/btop".source    = link "config/btop";
    ".config/git".source     = link "config/git";
    ".config/htop".source    = link "config/htop";
    ".config/incoming".source = link "config/incoming";
    ".config/PureRef".source  = link "config/PureRef";
  };
}
