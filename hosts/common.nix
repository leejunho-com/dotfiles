{ ... }:

{
  # Determinate Nix manages the Nix installation; disable nix-darwin's management
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ ];
}
