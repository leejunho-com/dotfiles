{ pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    inputs.xremap-nix.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    firefox
    mpv
  ];

  services.xremap = {
    enable = true;
    config = {
      keymap = [
        {
          name = "emacs navigation";
          application.not = [ "com.mitchellh.ghostty" "st-256color" ];
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
          application.not = [ "com.mitchellh.ghostty" "st-256color" ];
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
          application.not = [ "com.mitchellh.ghostty" "st-256color" ];
          remap = {
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            "Super-x" = "C-x";
            "Super-z" = "C-z";
            "Super-a" = "C-a";
          };
        }
        {
          name = "darwin-style shortcuts (terminal)";
          application.only = [ "com.mitchellh.ghostty" "st-256color" ];
          remap = {
            "Super-c" = "C-S-c";
            "Super-v" = "C-S-v";
          };
        }
        {
          name = "window switcher";
          application.not = [ "com.mitchellh.ghostty" "st-256color" ];
          remap = {
            "M-u" = "Super-Tab";
          };
        }
        {
          name = "firefox shortcuts";
          application.only = [ "firefox" ];
          remap = {
            "Super-t" = "C-t";
            "Super-w" = "C-w";
            "Super-n" = "C-n";
            "Super-l" = "C-l";
            "Super-r" = "C-r";
            "Super-f" = "C-f";
            "Super-S-t" = "C-S-t";
          };
        }
      ];
    };
  };
}
