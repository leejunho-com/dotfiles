{ user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/bios.nix
  ];

  networking.hostName = "thinkpad-x200s";

  boot.loader.grub.device = "/dev/sda";

  hardware.enableRedistributableFirmware = true;

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    xkb.options = "ctrl:nocaps";
  };
  services.displayManager.sddm.enable = true;

  # acpi_osi: mute button fix
  # nohpet: suppress NMI error on resume
  boot.kernelParams = [ "acpi_osi=Linux" "nohpet" ];

  # mei_me causes suspend errors
  boot.blacklistedKernelModules = [ "mei" "mei_me" ];

  # drm poll causes responsiveness issues on GMA 4500MHD
  boot.extraModprobeConfig = "options drm_kms_helper poll=N";

  services.tlp.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      LoginGraceTime = 30;
      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 48;
    };
  };

  users.users.${user}.initialPassword = "nixos";
}
