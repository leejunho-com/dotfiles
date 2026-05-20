{ user, ... }:

{
  # Determinate Nix manages the Nix installation; disable nix-darwin's management
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  services.skhd.enable = true;

  system.defaults = {
    # Appearance
    NSGlobalDomain.AppleInterfaceStyle = "Dark";                     # Appearance > Appearance: Dark
    NSGlobalDomain.NSTableViewDefaultSizeMode = 3;                   # Appearance > Sidebar icon size: Large

    # Desktop & Dock
    dock.tilesize = 16;                                              # Desktop & Dock > Size: Small
    dock.magnification = true;                                       # Desktop & Dock > Magnification: on
    dock.largesize = 128;                                            # Desktop & Dock > Magnification size: Large
    dock.autohide = true;                                            # Desktop & Dock > Automatically hide and show the Dock: on
    dock.mru-spaces = false;                                         # Desktop & Dock > Mission Control > Automatically rearrange Spaces based on most recent use: off
    finder.CreateDesktop = false;                                    # Desktop & Dock > Show Items on Desktop: none
    WindowManager.EnableStandardClickToShowDesktop = false;          # Desktop & Dock > Click wallpaper to reveal desktop: Only in Stage Manager

    # Finder
    finder.AppleShowAllExtensions = true;                            # Finder > Show all filename extensions: on

    # Keyboard
    NSGlobalDomain.KeyRepeat = 2;                                    # Keyboard > Key repeat rate: Fast
    NSGlobalDomain.InitialKeyRepeat = 15;                            # Keyboard > Delay until repeat: Short
    NSGlobalDomain.AppleKeyboardUIMode = 3;                          # Keyboard > Keyboard navigation: on
    NSGlobalDomain.ApplePressAndHoldEnabled = false;                 # Keyboard > Press & Hold: off (enables key repeat)

    CustomUserPreferences = {
      "NSGlobalDomain".AppleAccentColor = 1;                         # Appearance > Accent Color: Orange
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;   # no .DS_Store on network drives
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
    casks = [
      "alfred"
      "anki"
      "appcleaner"
      "cyberduck"
      "discord"
      "firefox"
      "ghostty"
      "github"
      "handbrake"
      "karabiner-elements"
      "obsidian"
      "plex"
      "proton-pass"
      "protonvpn"
      "visual-studio-code"
    ];
  };

  system.primaryUser = user;

  # Used for backwards compatibility — do not change
  system.stateVersion = 5;

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
}
