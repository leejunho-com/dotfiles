{ imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/bios.nix
  ];
  boot.loader.grub.device = "/dev/sda";
}
