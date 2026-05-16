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
          homeModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit user; };
          modules = [
            ./home/common.nix
            ./home/linux
            { home.stateVersion = "25.11"; }
          ] ++ homeModules;
        };
    in
    {
      darwinConfigurations = {
        # Set key to your hostname: `scutil --get LocalHostName`

        "mac-studio" = mkDarwin {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/darwin/workstation.nix ];
          homeModules = [ ./home/darwin/workstation.nix ];
        };

        "macbook-pro" = mkDarwin {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/darwin/labtop.nix ];
        };

        "macbook-neo" = mkDarwin {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/darwin/labtop.nix ];
        };

        "macbook-pro-2018" = mkDarwin {
          system = "x86_64-darwin";
          extraModules = [ ./hosts/darwin/labtop.nix ];
        };

        # Generic aarch64 darwin — used as fallback by install.sh
        "darwin" = mkDarwin {
          system = "aarch64-darwin";
        };

        # Generic x86_64 darwin — used as fallback by install.sh for Intel Macs
        "darwin-x86" = mkDarwin {
          system = "x86_64-darwin";
        };
      };

      # Standalone home-manager for non-NixOS Linux (Rocky, Fedora, WSL Ubuntu, etc.)
      # Apply with: home-manager switch --flake ~/code/dotfiles#<hostname>
      homeConfigurations = {
        # Generic linux — used as fallback by install.sh
        "linux" = mkLinux { system = "x86_64-linux"; };

        "wsl-fedora" = mkLinux {
          system = "x86_64-linux";
          homeModules = [ ./home/linux/desktop.nix ];
        };
      };
    };
}
