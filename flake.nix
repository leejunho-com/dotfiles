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
              home-manager.extraSpecialArgs = { inherit user; };
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

        # Generic aarch64 darwin — used as fallback by install.sh / nix-switch.sh
        "darwin" = mkDarwin {
          system = "aarch64-darwin";
          hostModules = [ ./modules/darwin/common.nix ];
        };

        # Generic x86_64 darwin — used as fallback for Intel Macs
        "darwin-x86" = mkDarwin {
          system = "x86_64-darwin";
          hostModules = [ ./modules/darwin/common.nix ];
        };
      };

      nixosConfigurations = {
        # Generic x86_64 NixOS — bare metal Intel / Parallels on Intel
        "nixos" = mkNixos {
          system = "x86_64-linux";
          hostModules = [ ./modules/nixos/common.nix ];
          homeModules = [ ./home/linux/desktop.nix ];
        };

        # Generic aarch64 NixOS — Parallels on Apple Silicon
        "nixos-arm" = mkNixos {
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

      # Standalone home-manager for non-NixOS Linux (Rocky, Fedora, WSL, etc.)
      # Apply with: home-manager switch --flake ~/code/dotfiles#<hostname>
      homeConfigurations = {
        # Generic linux — used as fallback by install.sh / nix-switch.sh
        "linux" = mkLinux { system = "x86_64-linux"; };

        "wsl-fedora" = mkLinux {
          system = "x86_64-linux";
          homeModules = [ ./home/linux/desktop.nix ];
        };
      };
    };
}
