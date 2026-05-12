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
          homeModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
            ./hosts/common.nix
            ./hosts/darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/common.nix
                  ./home/darwin
                ] ++ homeModules;
                home.stateVersion = "25.11";
              };
            }
          ] ++ extraModules;
        };

      mkLinux =
        {
          system,
          extraModules ? [ ],
          homeModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
            ./hosts/common.nix
            ./hosts/linux
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/common.nix
                  ./home/linux
                ] ++ homeModules;
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
          extraModules = [ ./hosts/darwin/mac-studio.nix ];
          homeModules = [ ./home/darwin/mac-studio.nix ];
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

      nixosConfigurations = {
        # Linux/WSL example
        # "my-linux" = mkLinux {
        #   system = "x86_64-linux";
        # };
      };
    };
}
