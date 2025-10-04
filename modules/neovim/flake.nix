{
  description = "Milo's custom neovim setup";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.expert.url = "github:elixir-lang/expert";

  outputs =
    inputs@{
      self,
      nixpkgs,
      expert,
    }:
    {
      packages = {
        aarch64-linux =
          let
            system = "aarch64-linux";
            pkgs = import nixpkgs {
              inherit system;
              overlays = import ./overlays.nix { inherit inputs system; };
            };
          in
          {
            inherit (pkgs) neovim-custom;
            default = pkgs.neovim-custom;
          };

        x86_64-linux =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
              inherit system;
              overlays = import ./overlays.nix { inherit inputs system; };
            };
          in
          {
            inherit (pkgs) neovim-custom;
            default = pkgs.neovim-custom;
          };

        aarch64-darwin =
          let
            system = "aarch64-darwin";
            pkgs = import nixpkgs {
              inherit system;
              overlays = import ./overlays.nix { inherit inputs system; };
            };
          in
          {
            inherit (pkgs) neovim-custom;
            default = pkgs.neovim-custom;
          };

        x86_64-darwin =
          let
            system = "x86_64-darwin";
            pkgs = import nixpkgs {
              inherit system;
              overlays = import ./overlays.nix { inherit inputs system; };
            };
          in
          {
            inherit (pkgs) neovim-custom;
            default = pkgs.neovim-custom;
          };
      };
    };
}
