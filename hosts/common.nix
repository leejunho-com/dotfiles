{ user, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ ];

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  system.primaryUser = user;

  # Used for backwards compatibility — do not change
  system.stateVersion = 5;

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
}
