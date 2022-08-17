{
  description = "Milo's custom neovim setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    /* neovim-nightly-overlay = { */
    /*   url = "github:nix-community/neovim-nightly-overlay"; */
    /*   inputs.nixpkgs.follows = "nixpkgs"; */
    /* }; */
  };

  outputs = inputs @
  { self
  , nixpkgs
  /* , neovim-nightly-overlay */
  }: let
    configDir = ./config;
  in {
    overlays.default = final: prev: {
      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs(old: {
        buildInputs = old.buildInputs ++ (with prev.pkgs; [
          elixir_ls
          /* nodePackages.eslint */
          nodePackages.typescript-language-server
          nodePackages.typescript
          rnix-lsp
          sumneko-lua-language-server
          terraform-ls
          vscode-extensions.bradlc.vscode-tailwindcss
          /* node-debug2 */
        ]);
      });

      neovim-custom = final.callPackage ./neovim.nix {};
    };

    packages = {
      x86_64-linux = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
        };
      in {
        inherit (pkgs) neovim-custom;
        default = pkgs.neovim-custom;
      };

      x86_64-darwin = let
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
          overlays = [ self.overlays.default ];
        };
      in {
        inherit (pkgs) neovim-custom;
        default = pkgs.neovim-custom;
      };
    };
  };
}
