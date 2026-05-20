{
  nixpkgs.config.allowUnfree = true;
  hardware.parallels.enable = true;

  # Inject DISPLAY so prltoolsd can reach XWayland for clipboard sharing
  systemd.services.prltoolsd.environment = {
    DISPLAY = ":0";
  };
}
