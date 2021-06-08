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
{
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
#nixpkgs = { inherit nixpkgs.pkgs; };
nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
nix.registry.nixpkgs.flake = nixpkgs;
}
          #/etc/nixos/configurations.nix
          (./. + "/hosts/${host}/default.nix")
          home-manager.nixosModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            users.users.${user} = {
              home = "/home/${user}";
              description = "Milo Gertjejansen";
              createHome = true;
              isNormalUser = true;
              extraGroups = [ "wheel" ];
            };
            home-manager.verbose = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = with self.homeManagerModules; {
              imports = [ (./. + "/hosts/${host}/users/${user}") ];
              nixpkgs.overlays = nixpkgsConfig.overlays;
            };
          }
        ];
    in {
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
          #inputs = inputs;
          modules = mkNixosConfig {
            host = "theseus";
            user = "milo";
          };
        };
      };
    };
}
