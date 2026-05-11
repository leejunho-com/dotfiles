{
  description = "leejunho dotfiles — nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      user = "leejunho";

      mkDarwin =
        {
          system,
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
            ./hosts/common.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/common.nix
                  ./home/darwin.nix
                ];
                home.stateVersion = "25.11";
              };
            }
          ] ++ extraModules;
        };
    in
    {
      darwinConfigurations = {
        # Set key to your hostname: `scutil --get LocalHostName`

        "mac-studio" = mkDarwin {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/mac-studio.nix ];
        };

        # MacBook example (no extraModules = common only)
        # "Juns-MacBook-Pro" = mkDarwin {
        #   system = "aarch64-darwin";
        # };

        # Intel Mac example
        # "Juns-MacBook-Intel" = mkDarwin {
        #   system = "x86_64-darwin";
        # };
      };
    };
}
