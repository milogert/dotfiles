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

      mkUserConfig = { pkgs, host, user }: let
        user_path = (./. + "/hosts/${host}/users/${user}");
        config_path = (user_path + "/config.nix");
        config = import config_path { inherit pkgs user; };
      in {
        home-manager.users.${user} = with self.homeManagerModules; {
          imports = [ user_path ];
          nixpkgs = nixpkgsConfig;
        };
        users.users.${user} = config;
      };

      mkCommonConfig = { host, users }: let
        mkUserConfigWrapped = user:
          ({ pkgs, ... }: mkUserConfig { inherit pkgs host user; });
      in [
        (./. + "/hosts/${host}/default.nix")
        ({ pkgs, ... }: {
          environment.variables.HOSTNAME = host;
          nixpkgs = nixpkgsConfig;
          home-manager.verbose = true;
          home-manager.useUserPackages = true;
        })
      ] ++ (builtins.map mkUserConfigWrapped users);

      mkDarwinConfig = { host, users }:
        (mkCommonConfig { inherit host users; }) ++ [
          home-manager.darwinModules.home-manager
        ];

      mkNixosConfig = { host, users }:
        (mkCommonConfig { inherit host users; }) ++ [
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
    in rec {
      darwinConfigurations = {
        worktop = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinConfig {
            host = "worktop";
            users = ["milo"];
          };
        };
      };

      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "theseus";
            users = ["milo"];
          };
        };

        rig = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "rig";
            users = ["milo"];
          };
        };
      };
    };
}
