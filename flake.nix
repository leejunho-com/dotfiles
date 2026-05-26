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

    xremap-nix = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      xremap-nix,
      ...
    }@inputs:
    let
      user = "leejunho";

      mkDarwin =
        {
          system,
          hostModules ? [ ],
          homeModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
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
          ] ++ hostModules;
        };

      mkLinux =
        {
          system,
          homeModules ? [ ],
          username ? user,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { user = username; inherit inputs; };
          modules = [
            ./home/common.nix
            ./home/linux
            { home.stateVersion = "25.11"; }
          ] ++ homeModules;
        };

      mkNixos =
        {
          system,
          hostModules ? [ ],
          homeModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user; };
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user inputs; };
              home-manager.users.${user} = {
                imports = [
                  ./home/common.nix
                  ./home/linux/nixos.nix
                ] ++ homeModules;
                home.stateVersion = "25.11";
              };
            }
          ] ++ hostModules;
        };
    in
    {
      darwinConfigurations = {
        # Set key to your hostname: `scutil --get LocalHostName`

        "mac-studio" = mkDarwin {
          system = "aarch64-darwin";
          hostModules = [ ./hosts/mac-studio ];
          homeModules = [ ./home/darwin/workstation.nix ];
        };

        "macbook-pro" = mkDarwin {
          system = "aarch64-darwin";
          hostModules = [ ./hosts/macbook-pro ];
        };

        "macbook-neo" = mkDarwin {
          system = "aarch64-darwin";
          hostModules = [ ./hosts/macbook-neo ];
        };

        "macbook-pro-2018" = mkDarwin {
          system = "x86_64-darwin";
          hostModules = [ ./hosts/macbook-pro-2018 ];
        };

        # Generic fallbacks — used by install.sh / nix-switch.sh when no hostname match
        "default" = mkDarwin {
          system = "aarch64-darwin";
          hostModules = [ ./modules/darwin/common.nix ];
        };

        "default-x86" = mkDarwin {
          system = "x86_64-darwin";
          hostModules = [ ./modules/darwin/common.nix ];
        };
      };

      nixosConfigurations = {
        # Generic fallbacks — used by install.sh / nix-switch.sh when no hostname match
        "default" = mkNixos {
          system = "x86_64-linux";
          hostModules = [ ./modules/nixos/common.nix ];
          homeModules = [ ./home/linux/desktop.nix ];
        };

        "default-arm" = mkNixos {
          system = "aarch64-linux";
          hostModules = [ ./modules/nixos/common.nix ];
          homeModules = [ ./home/linux/desktop.nix ];
        };

        "nixos-vm" = mkNixos {
          system = "aarch64-linux";
          hostModules = [ ./hosts/nixos-vm ];
          homeModules = [ ./home/linux/desktop.nix ];
        };
      };

      # Standalone home-manager for non-nixos linux (Rocky, Fedora, WSL, etc.)
      # Apply with: home-manager switch --flake ~/code/dotfiles#<hostname>
      homeConfigurations = {
        # Generic fallbacks — used by install.sh / nix-switch.sh when no hostname match
        "default"     = mkLinux { system = "x86_64-linux"; };
        "default-arm" = mkLinux { system = "aarch64-linux"; };

        "galaxy-tab" = mkLinux {
          system = "aarch64-linux";
          username = "droid";
          homeModules = [ ./home/linux/desktop.nix ];
        };

        "wsl-fedora" = mkLinux {
          system = "x86_64-linux";
          homeModules = [ ./home/linux/desktop.nix ];
        };
      };
    };
}
