{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in

{
  home.file.".config/private".source = link "private";

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=hangul

    [Groups/0/Items/0]
    Name=keyboard-us
    Priority=0

    [Groups/0/Items/1]
    Name=hangul
    Priority=1

    [GroupOrder]
    0=Default
  '';
  };
}
