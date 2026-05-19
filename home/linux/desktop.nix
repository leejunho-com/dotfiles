{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    ghostty
    mpv
    wl-clipboard
  ];
}
