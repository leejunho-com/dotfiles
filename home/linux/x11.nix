{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./gui.nix ];

  home.file.".xinitrc".source = link "i3/xinitrc";
  home.file.".config/i3/config".source = link "i3/config";
  home.file.".config/i3status/config".source = link "i3/i3status.conf";

  home.file.".Xresources".source = link "urxvt/Xresources";

  home.packages = with pkgs; [
    xclip
    xrdb
    rofi
    pulsemixer
    alttab
    feh
    unclutter
    picom
    (rxvt-unicode.override {
      rxvt-unicode-unwrapped = rxvt-unicode-unwrapped.override { emojiSupport = true; };
    })
    ueberzugpp
  ];

  services.xremap.withX11 = true;
}
