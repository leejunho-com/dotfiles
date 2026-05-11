{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";

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
    zsh-autosuggestions zsh-syntax-highlighting
    zsh-powerlevel10k asciinema asciinema-agg

    # dev
    nodejs
    neovim delta lazygit gh
  ];

  # dotfiles → ~/.config/ symlinks
  home.file = {
    ".config/nvim".source   = link "nvim";
    ".config/yazi".source   = link "yazi";
    ".config/mpv".source    = link "mpv";
    ".config/tmux".source   = link "tmux";
    ".config/pip".source    = link "pip";
    ".config/yt-dlp".source = link "yt-dlp";
  };
}
