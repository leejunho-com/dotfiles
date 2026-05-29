# standalone home-manager only (non-nixos linux)
{ ... }:

{
  imports = [ ./common.nix ];

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
