{ user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/bios.nix
    ../../modules/nixos/x11.nix
  ];

  networking.hostName = "thinkpad-x200s";

  boot.loader.grub.device = "/dev/sda";

  hardware.enableRedistributableFirmware = true;

  # acpi_osi: mute button fix
  # nohpet: suppress NMI error on resume
  boot.kernelParams = [ "acpi_osi=Linux" "nohpet" ];

  # mei_me causes suspend errors
  boot.blacklistedKernelModules = [ "mei" "mei_me" ];

  # drm poll causes responsiveness issues on GMA 4500MHD
  boot.extraModprobeConfig = "options drm_kms_helper poll=N";

  services.tlp.enable = true;

  home-manager.users.${user}.services.xremap.config.modmap = [
    {
      name = "built-in keyboard: alt to super";
      device.only = [ "AT Translated Set 2 keyboard" ];
      remap = { "LeftAlt" = "LeftMeta"; };
    }
    {
      name = "built-in keyboard: super to alt";
      device.only = [ "AT Translated Set 2 keyboard" ];
      remap = { "LeftMeta" = "LeftAlt"; };
    }
    {
      name = "built-in keyboard: grave/backspace/escape rotation";
      device.only = [ "AT Translated Set 2 keyboard" ];
      remap = {
        "Grave" = "Esc";
        "BackSpace" = "Grave";
        "Esc" = "BackSpace";
      };
    }
  ];
}
