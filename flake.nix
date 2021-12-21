{
  description = "Milo's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "path:///home/milo/git/nixpkgs";

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
  , nixpkgs
  , neovim-nightly-overlay
  }:
    let
      overlays = self: super:
        {
          plexPassRaw = super.plexRaw.overrideAttrs (old: rec {
            version = "1.24.4.5081-e362dc1ee";
            name = "${old.pname}-${version}";
            src = super.fetchurl {
              url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
              sha256 = "sha256-NVAWuDPMj0Rilh+jaiREXQhy7SlLJNwLz1XWgynwL54=";
            };
          });
          plexPass = super.plex.override { plexRaw = self.plexPassRaw; };
        };

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          firefox.drmSupport = true;
          permittedInsecurePackages = [
            "libav-11.12"
          ];
        };
        overlays = [
          overlays
          neovim-nightly-overlay.overlay
        ];
      };

      mkUserConfig = { pkgs, host, user }: let
        user_host_path = (./. + "/hosts/${host}/users");
        common_config = (user_host_path + "/_common");
        user_path = (user_host_path + "/${user}");
        config_path = (user_path + "/config.nix");
        config = import config_path { inherit pkgs user; };
      in {
        home-manager.users.${user} = with self.homeManagerModules; {
          imports = [ user_path common_config ];
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
          nix.registry.nixpkgs.flake = nixpkgs;
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
          system = "x86_64-darwin";
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

        hog = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "hog";
            users = ["milo"];
          };
        };
      };
    };
}
