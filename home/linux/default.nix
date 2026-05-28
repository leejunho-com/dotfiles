# standalone home-manager only (non-nixos linux)
{ ... }:

{
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
