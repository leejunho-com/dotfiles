{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./gui.nix ];

  home.packages = with pkgs; [
    wl-clipboard
  ];

  home.file.".config/hypr".source = link "hyprland";

  services.xremap.withWlroots = true;
}
