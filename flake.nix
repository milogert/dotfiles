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
  };

  outputs = inputs @
  { self
  , darwin
  , flake-utils
  , home-manager
  , nixpkgs
  }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          firefox.drmSupport = true;
        };
      };

      mkCommonConfig =
        { host
        , user
        }: [
          (./. + "/hosts/${host}/default.nix")
          ({ pkgs, ... }: {
            environment.variables.HOSTNAME = host;
            nixpkgs = nixpkgsConfig;
            home-manager.verbose = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = with self.homeManagerModules; {
              imports = [ (./. + "/hosts/${host}/users/${user}") ];
              nixpkgs = nixpkgsConfig;
            };
            users.users.${user} =
              import (./. + "/hosts/${host}/users/${user}/config.nix")
                { inherit pkgs user; };
          })
        ];

      mkDarwinConfig =
        { host
        , user
        }: (mkCommonConfig { inherit host user; }) ++ [
          home-manager.darwinModules.home-manager
        ];

      mkNixosConfig =
        { host
        , user
        }: (mkCommonConfig { inherit host user; }) ++ [
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision =
              nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
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

        rig = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "rig";
            user = "milo";
          };
        };
      };
    };
}
