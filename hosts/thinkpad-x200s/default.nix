{ imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/bios.nix
  ];

  boot.loader.grub.device = "/dev/sda";

  # wifi firmware (intel iwlwifi)
  hardware.enableRedistributableFirmware = true;

  # acpi_osi: mute button fix
  # nohpet: suppress NMI error on resume
  boot.kernelParams = [ "acpi_osi=Linux" "nohpet" ];

  # mei_me causes suspend errors
  boot.blacklistedKernelModules = [ "mei" "mei_me" ];

  # drm poll causes responsiveness issues on GMA 4500MHD
  boot.extraModprobeConfig = "options drm_kms_helper poll=N";

  # power management
  services.tlp.enable = true;
}
