{ pkgs, inputs, ... }:

{
  imports = [ inputs.xremap-nix.homeManagerModules.default ];

  home.packages = with pkgs; [
    firefox
    ghostty
    mpv
    wl-clipboard
  ];

  services.xremap = {
    enable = true;
    withHypr = true;
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
      ];
    };
  };
}
