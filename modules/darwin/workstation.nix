{ user, pkgs, ... }:

{
  homebrew.casks = [
    "kid3"
  ];

  environment.etc."exports".text = ''
    /Volumes/dock -network 192.168.50.0 -mask 255.255.255.0
  '';

  services.sketchybar.enable = true;
  services.jankyborders = {
    enable = true;
    style = "round";
    width = 8.0;
    hidpi = true;
    active_color = "0xfff37021";
    inactive_color = "0x00000000";
  };

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
  };
}
