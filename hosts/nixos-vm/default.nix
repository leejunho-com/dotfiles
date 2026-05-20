{ imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/parallels.nix
  ];

  networking.hostName = "nixos-vm";

  services.openssh.enable = true;
}
