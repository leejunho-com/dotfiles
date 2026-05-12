{ user, pkgs, ... }:

{
  services.sketchybar.enable = true;
  services.jankyborders.enable = true;

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
  };

  home-manager.users.${user}.home.packages = with pkgs; [
    transmission_4
  ];

  # transmission-daemon via launchd
  # nix-darwin has no services.transmission (NixOS/systemd only)
  # --foreground required: launchd detects daemon fork as crash-loop
  launchd.user.agents.transmission = {
    serviceConfig = {
      Label = "org.transmissionbt.transmission";
      ProgramArguments = [
        "${pkgs.transmission_4}/bin/transmission-daemon"
        "--foreground"
        "--config-dir"
        "/Users/${user}/.config/transmission-daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/${user}/Library/Logs/transmission.log";
      StandardErrorPath = "/Users/${user}/Library/Logs/transmission.err";
    };
  };
}
