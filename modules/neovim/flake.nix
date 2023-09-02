{
  description = "Milo's custom neovim setup";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs @ { self, nixpkgs }: {
    overlays.default = final: prev: {
      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs(old: {
        buildInputs = old.buildInputs ++ (with prev.pkgs; [
          elixir_ls
          /* nodePackages.eslint */
          # deno
          nodePackages.typescript-language-server
          nodePackages.typescript
          nil
          sumneko-lua-language-server
          terraform-ls
          vscode-extensions.bradlc.vscode-tailwindcss
          statix
          stylua
          /* node-debug2 */
        ]);
      });

      neovim-custom = final.callPackage ./neovim.nix {};

      vimPlugins = prev.vimPlugins // {
        # Remove when https://github.com/j-hui/fidget.nvim/issues/131 resolves.
        fidget-nvim = prev.vimPlugins.fidget-nvim.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "j-hui";
            repo = "fidget.nvim";
            rev = "90c22e47be057562ee9566bad313ad42d622c1d3";
            sha256 = "1ga6pxz89687km1mwisd4vfl1bpw6gg100v9xcfjks03zc1bywrp";
          };
        });

        # Remove when fzf-lua has query_delay in nixos.
        fzf-lua = prev.vimPlugins.fzf-lua.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "ibhagwan";
            repo = "fzf-lua";
            rev = "c3c71df6ffba3cc90335c538fad81aa7a0182e57";
            sha256 = "07n1sg582wxpvnw5n0r504dfc9jzrj01j5an0vzgg801hjk5ari8";
          };
        });

        # Dev overlays.
        # art-nvim = old.pkgs.vimUtils.buildVimPlugin {
        #   name = "art-nvim";
        #   src = /Users/milo/projects/art-nvim;
        # };

        # git-permalink-nvim = old.pkgs.vimUtils.buildVimPlugin {
        #   name = "git-permalink-nvim";
        #   src = /Users/milo/git/git-permalink-nvim;
        # };

        # TODO remove when fzf-lua implementation is merged to NixOS.
        octo-nvim = prev.pkgs.vimUtils.buildVimPlugin {
          name = "octo-nvim";
          src = /Users/milo/git/octo.nvim;
        };
      };
    };

    packages = {
      aarch64-linux = let
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          overlays = [ self.overlays.default ];
        };
      in {
        inherit (pkgs) neovim-custom;
        default = pkgs.neovim-custom;
      };

      x86_64-linux = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
        };
      in {
        inherit (pkgs) neovim-custom;
        default = pkgs.neovim-custom;
      };

      aarch64-darwin = let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
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
