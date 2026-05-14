{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = user;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";

  home.packages = with pkgs; [
    # essential
    bat eza fd fzf ripgrep tree jq wget
    coreutils findutils gnused gawk gnugrep
    unar p7zip rsync convmv mc w3m
    htop btop duf iperf3 nmap
    wireguard-tools zoxide
    magic-wormhole tealdeer yazi poppler

    # media
    ffmpeg ffmpegthumbnailer imagemagick
    mediainfo yt-dlp viu chafa resvg exiftool

    # ricing
    fastfetch figlet lolcat cmatrix
    asciinema asciinema-agg ascii-image-converter

    # dev
    nodejs
    neovim delta lazygit gh nvd
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
      source ${dotfiles}/zsh/zshrc
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
    extraConfig = "source-file ${config.home.homeDirectory}/code/dotfiles/tmux/tmux.conf";
  };

  # dotfiles → ~/ and ~/.config/ symlinks
  home.file = {
    ".p10k.zsh".source      = link "zsh/p10k.zsh";
    ".vimrc".source         = link "vim/vimrc";
    ".config/ghostty".source = link "ghostty";
    ".config/nvim".source   = link "nvim";
    ".config/yazi".source   = link "yazi";
    ".config/mpv".source    = link "mpv";
    ".config/pip".source    = link "pip";
    ".config/fzf".source    = link "fzf";
    ".config/yt-dlp".source  = link "yt-dlp";
    ".config/btop".source    = link "btop";
    ".config/git".source     = link "git";
    ".config/htop".source    = link "htop";
    ".config/incoming".source = link "incoming";
    ".config/PureRef".source  = link "PureRef";
  };
}
