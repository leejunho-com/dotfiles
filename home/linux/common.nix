{ pkgs, inputs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in

{
  imports = [ inputs.xremap-nix.homeManagerModules.default ];

  home.file.".config/private".source = link "private";

  home.packages = with pkgs; [
    fcitx5
    fcitx5-hangul
    fcitx5-gtk
  ];

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

  services.xremap = {
    enable = true;
    config = {
      keymap = [
        {
          name = "emacs navigation";
          remap = {
            "C-p" = "up";
            "C-n" = "down";
            "C-f" = "right";
            "C-b" = "left";
            "C-h" = "backspace";
            "M-f" = "M-right";
            "M-b" = "M-left";
          };
        }
        {
          name = "emacs editing";
          application.not = [ "com.mitchellh.ghostty" ];
          remap = {
            "C-a" = "home";
            "C-e" = "end";
            "C-d" = "delete";
            "C-k" = [ "S-end" "delete" ];
            "C-u" = [ "S-home" "delete" ];
            "C-S-f" = "S-right";
            "C-S-b" = "S-left";
            "C-S-n" = "S-down";
            "C-S-p" = "S-up";
          };
        }
        {
          name = "darwin-style shortcuts";
          application.not = [ "com.mitchellh.ghostty" ];
          remap = {
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            "Super-x" = "C-x";
            "Super-z" = "C-z";
            "Super-a" = "C-a";
          };
        }
      ];
    };
  };
}
