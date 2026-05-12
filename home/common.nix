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
    wireguard-tools tmux zoxide
    magic-wormhole tealdeer yazi poppler

    # media
    ffmpeg ffmpegthumbnailer imagemagick
    mediainfo yt-dlp viu chafa resvg exiftool

    # ricing
    fastfetch figlet lolcat cmatrix
    asciinema asciinema-agg ascii-image-converter

    # dev
    nodejs
    neovim delta lazygit gh
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

  # dotfiles → ~/ and ~/.config/ symlinks
  home.file = {
    ".p10k.zsh".source      = link "zsh/p10k.zsh";
    ".vimrc".source         = link "vim/vimrc";
    ".config/nvim".source   = link "nvim";
    ".config/yazi".source   = link "yazi";
    ".config/mpv".source    = link "mpv";
    ".config/tmux".source   = link "tmux";
    ".config/pip".source    = link "pip";
    ".config/fzf".source    = link "fzf";
    ".config/yt-dlp".source = link "yt-dlp";
  };
}
