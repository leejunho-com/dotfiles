{
  nixpkgs.config.allowUnfree = true;
  hardware.parallels.enable = true;

  systemd.services.prltoolsd.environment = {
    DISPLAY = ":0";
    WAYLAND_DISPLAY = "wayland-1";
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
}
