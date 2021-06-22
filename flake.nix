{
  description = "Milo's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @
  { self
  , darwin
  , flake-utils
  , home-manager
  , neovim-nightly-overlay
  , nixpkgs
  }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = [
          neovim-nightly-overlay.overlay
        ];
      };

      mkDarwinConfig =
        { host
        , user
        }: [
          (./. + "/hosts/${host}/default.nix")
          home-manager.darwinModules.home-manager
          {
            environment.variables.HOSTNAME = host;
            nixpkgs = nixpkgsConfig;
            users.users.${user}.home = "/Users/${user}";
            home-manager.useUserPackages = true;
            home-manager.users.${user} = with self.homeManagerModules; {
              imports = [ (./. + "/hosts/${host}/users/${user}") ];
              nixpkgs.overlays = nixpkgsConfig.overlays;
            };
          }
        ];

      mkNixosConfig =
        { host
        , user
        }: [
          (./. + "/hosts/${host}/default.nix")
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            environment.variables.HOSTNAME = host;
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            users.users.${user} = import (./. + "/hosts/${host}/users/${user}/config.nix")
              { inherit pkgs user; };
            nixpkgs = nixpkgsConfig;
            home-manager.verbose = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = with self.homeManagerModules; {
              imports = [ (./. + "/hosts/${host}/users/${user}") ];
              nixpkgs = nixpkgsConfig;
            };
          })
        ];
    in rec {
      darwinConfigurations = {
        worktop = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinConfig {
            host = "worktop";
            user = "milo";
          };
        };
      };

      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "theseus";
            user = "milo";
          };
        };
      };
    };
}
