{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  home.file = {
    ".config/private".source = link "private";
  };
}
