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
      url = "path:./modules/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      neovim-custom,
      nixpkgs,
      openclaw,
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

        tt-rss-plugin-feediron = prev.tt-rss-plugin-feediron.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "feediron";
            repo = "ttrss_plugin-feediron";
            rev = "5573ffde9c2c782eae1616e86127fb27e150130a";
            sha256 = "1c737i390fc1wwdw1jh2bab92pmzlmyh75wnmnxldvaajd01fki9";
          };
        });

        pi-coding-agent = prev.callPackage ./packages/pi-coding-agent/package.nix { };
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
          openclaw.overlays.default
          (final: prev: {
            openclaw-gateway =
              final.runCommand "openclaw-gateway-fixed"
                {
                  inherit (prev.openclaw-gateway) meta;
                  nativeBuildInputs = [ final.gnused ];
                }
                ''
                  cp -r ${prev.openclaw-gateway} $out
                  chmod -R u+w $out

                  # Keep plugin manifests next to the built extension bundles so
                  # the gateway can discover packaged extensions correctly.
                  for ext_dir in $out/lib/openclaw/extensions/*/; do
                    ext_name=$(basename "$ext_dir")
                    manifest="$ext_dir/openclaw.plugin.json"
                    dist_dir="$out/lib/openclaw/dist/extensions/$ext_name"
                    if [ -f "$manifest" ] && [ -d "$dist_dir" ]; then
                      cp "$manifest" "$dist_dir/"
                    fi
                  done

                  for wrapper in $out/bin/*; do
                    if [ -f "$wrapper" ]; then
                      sed -i "s|${prev.openclaw-gateway}|$out|g" "$wrapper"
                    fi
                  done
                '';
          })
          (final: prev: {
            openclaw = final.symlinkJoin {
              name = "openclaw";
              paths = [ final.openclaw-gateway ];
            };
          })
        ];
      };

      mkUserConfig =
        {
          pkgs,
          host,
          type,
          user,
        }:
        let
          user_host_path = ./. + "/hosts/${host}/users";
          common_config = "${user_host_path}/_common";
          common_user_config = ./. + "/hosts/_common/users/${user}";
          user_path = "${user_host_path}/${user}";
          config_path = "${user_path}/config.nix";
          config = import config_path { inherit pkgs user; };
          home_type_path = ./. + "/hosts/_common/home/types/${type}.nix";
        in
        {
          home-manager.users.${user} = {
            imports = [
              openclaw.homeManagerModules.openclaw
              user_path
              common_config
              common_user_config
              home_type_path
            ];
            nixpkgs = nixpkgsConfig;
          };
          users.users.${user} = config;
        };

      mkCommonConfig =
        {
          host,
          type,
          users,
        }:
        let
          mkUserConfigWrapped =
            user:
            (
              { pkgs, ... }:
              mkUserConfig {
                inherit
                  pkgs
                  host
                  type
                  user
                  ;
              }
            );
        in
        [
          (./. + "/hosts/${host}/default.nix")
          (./. + "/hosts/_common/types/${type}.nix")
          (
            { pkgs, ... }:
            {
              nix.registry.nixpkgs.flake = nixpkgs;
              # Temp fix
              # nix.settings.sandbox = false;
              # nix.nixPath = "nixpkgs=flake:nixpkgs";
              environment.variables.HOSTNAME = host;
              nixpkgs = nixpkgsConfig;
              home-manager.verbose = false;
              home-manager.useUserPackages = true;
            }
          )
        ]
        ++ (builtins.map mkUserConfigWrapped users);

      mkDarwinConfig =
        {
          host,
          type,
          users,
        }:
        (mkCommonConfig { inherit host type users; })
        ++ [
          home-manager.darwinModules.home-manager
          openclaw.darwinModules.openclaw
        ];

      mkNixosConfig =
        {
          host,
          type,
          users,
        }:
        (mkCommonConfig { inherit host type users; })
        ++ [
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
    in
    {
      darwinConfigurations = {
        minotaur = darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "minotaur";
            users = [ "milo" ];
            type = "desktop";
          };
        };

        nutop = darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "nutop";
            users = [ "milo" ];
            type = "desktop";
          };
        };
      };

      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "theseus";
            users = [ "milo" ];
            type = "desktop";
          };
        };

        hog = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "hog";
            users = [ "milo" ];
            type = "headless";
          };
        };

        "remote-hog" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosConfig {
            host = "remote-hog";
            users = [ "milo" ];
            type = "headless";
          };
        };

        veem = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = mkNixosConfig {
            host = "veem";
            users = [ "milo" ];
            type = "desktop";
          };
        };
      };

      packages =
        let
          mkPkgs =
            system:
            import nixpkgs {
              inherit system;
              inherit (nixpkgsConfig) config overlays;
            };
        in
        {
          aarch64-linux =
            let
              pkgs = mkPkgs "aarch64-linux";
            in
            {
              neovim = neovim-custom.packages.aarch64-linux.default;
              openclaw = pkgs.openclaw;
              pi-coding-agent = pkgs.pi-coding-agent;
            };

          x86_64-linux =
            let
              pkgs = mkPkgs "x86_64-linux";
            in
            {
              neovim = neovim-custom.packages.x86_64-linux.default;
              openclaw = pkgs.openclaw;
              pi-coding-agent = pkgs.pi-coding-agent;
            };

          aarch64-darwin =
            let
              pkgs = mkPkgs "aarch64-darwin";
            in
            {
              neovim = neovim-custom.packages.aarch64-darwin.default;
              openclaw = pkgs.openclaw;
              pi-coding-agent = pkgs.pi-coding-agent;
            };

          x86_64-darwin =
            let
              pkgs = mkPkgs "x86_64-darwin";
            in
            {
              neovim = neovim-custom.packages.x86_64-darwin.default;
              openclaw = pkgs.openclaw;
              pi-coding-agent = pkgs.pi-coding-agent;
            };
        };
    };
}
