{
  description = "Milo's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "path:///Users/milo/git/nixpkgs";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-custom = {
      url = "path:modules/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @
  { self
  , nixpkgs
  , darwin
  , home-manager
  , neovim-custom
  }:
    let
      overlays = final: prev: {
        plexPassRaw = prev.plexRaw.overrideAttrs (old: rec {
          version = "1.28.1.6092-87136b92b";
          name = "${old.pname}-${version}";
          src = prev.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-4w8bCHjtIBuuFrVq2lc6dkjzo4tE2c6XPx/LdjbowDY=";
          };
        });

        plexPass = prev.plex.override { plexRaw = final.plexPassRaw; };
      };

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          firefox.drmSupport = true;
          permittedInsecurePackages = [
            "libav-11.12"
          ];
        };
        overlays = [
          overlays
          neovim-custom.overlays.default
        ];
      };

      mkUserConfig = { pkgs, host, type, user }: let
        user_host_path = ./. + "/hosts/${host}/users";
        common_config = "${user_host_path}/_common";
        common_user_config = ./. + "/hosts/_common/users/${user}";
        user_path = "${user_host_path }/${user}";
        config_path = "${user_path}/config.nix";
        config = import config_path { inherit pkgs user; };
        home_type_path = ./. + "/hosts/_common/home/types/${type}.nix";
      in {
        home-manager.users.${user} = {
          imports = [
            user_path
            common_config
            common_user_config
            home_type_path
          ];
          nixpkgs = nixpkgsConfig;
        };
        users.users.${user} = config;
      };

      mkCommonConfig = { host, type, users }: let
        mkUserConfigWrapped = user:
          ({ pkgs, ... }: mkUserConfig { inherit pkgs host type user; });
      in [
        (./. + "/hosts/${host}/default.nix")
        (./. + "/hosts/_common/types/${type}.nix")
        ({ pkgs, ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          environment.variables.HOSTNAME = host;
          nixpkgs = nixpkgsConfig;
          home-manager.verbose = false;
          home-manager.useUserPackages = true;
        })
      ] ++ (builtins.map mkUserConfigWrapped users);

      mkDarwinConfig = { host, type, users }:
        (mkCommonConfig { inherit host type users; }) ++ [
          home-manager.darwinModules.home-manager
        ];

      mkNixosConfig = { host, type, users }:
        (mkCommonConfig { inherit host type users; }) ++ [
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
    in {
      darwinConfigurations = {
        coucher = darwin.lib.darwinSystem {
          inherit inputs;
          system = "x86_64-darwin";
          modules = mkDarwinConfig {
            host = "coucher";
            users = ["milo"];
            type = "desktop";
          };
        };

        minotaur = darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "minotaur";
            users = ["milo"];
            type = "desktop";
          };
        };

        nutop = darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "nutop";
            users = ["milo"];
            type = "desktop";
          };
        };
      };

      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "theseus";
            users = ["milo"];
            type = "desktop";
          };
        };

        hog = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "hog";
            users = ["milo"];
            type = "headless";
          };
        };

        veem = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = mkNixosConfig {
            host = "veem";
            users = ["milo"];
            type = "desktop";
          };
        };
      };

      packages = {
        aarch64-linux = {
          neovim = neovim-custom.packages.aarch64-linux.default;
        };

        x86_64-linux = {
          neovim = neovim-custom.packages.x86_64-linux.default;
        };

        aarch64-darwin = {
          neovim = neovim-custom.packages.aarch64-darwin.default;
        };

        x86_64-darwin = {
          neovim = neovim-custom.packages.x86_64-darwin.default;
        };
      };
    };
}
