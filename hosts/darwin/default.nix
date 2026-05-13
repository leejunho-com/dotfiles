{ user, ... }:

{
  services.skhd.enable = true;

  system.defaults = {
    dock.autohide = true;                               # hide dock automatically
    finder.AppleShowAllExtensions = true;               # show all file extensions
    # finder.QuitMenuItem = true;                       # allow quitting Finder via Cmd+Q
    NSGlobalDomain.AppleInterfaceStyle = "Dark";        # dark mode
    NSGlobalDomain.ApplePressAndHoldEnabled = false;    # enable key repeat (disable accent popup)
    CustomUserPreferences = {
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;  # no .DS_Store on network drives
    };
  };

  system.primaryUser = user;

  # Used for backwards compatibility — do not change
  system.stateVersion = 5;

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
}
