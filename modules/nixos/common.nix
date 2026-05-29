{ pkgs, user, ... }:

{
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "permanent";
  };

  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-hangul
      fcitx5-gtk
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      LoginGraceTime = 30;
      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 48;
    };
  };

  hardware.uinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
