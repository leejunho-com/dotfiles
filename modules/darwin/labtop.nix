{ ... }:

{
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
