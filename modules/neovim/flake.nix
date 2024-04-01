{
  description = "Milo's custom neovim setup";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs @ { self, nixpkgs }: {
    overlays.default = final: prev: {
      wrapNeovim = prev.wrapNeovim.overrideAttrs(old: {
      });

      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs(old: {
        buildInputs = old.buildInputs ++ (with prev.pkgs; [
          # deno
          /* node-debug2 */
          /* nodePackages.eslint */
          elixir_ls
          nil
          nodePackages.typescript
          nodePackages.typescript-language-server
          statix
          stylua
          sumneko-lua-language-server
          terraform-ls
          texlab
          vscode-extensions.bradlc.vscode-tailwindcss
        ]);
      });

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
            rev = "1ff0278882db9786fef6f77cbcea7d8fa4b9ccee";
            sha256 = "0gsdsmjf1jdsbsrvpzssfr496b0jk2j78lqffdanbykpcim9s7bs";
          };
        });

        gitsigns-nvim = prev.vimPlugins.gitsigns-nvim.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "lewis6991";
            repo = "gitsigns.nvim";
            rev = "5a9a6ac29a7805c4783cda21b80a1e361964b3f2";
            sha256 = "1vgs97iik9ziwbqv1xbs920qizcnshcpibj17mbsdr8lax8iycpl";
          };
        });

        # Dev overlays.
        # art-nvim = prev.pkgs.vimUtils.buildVimPlugin {
        #   name = "art-nvim";
        #   src = /Users/milo/projects/art-nvim;
        # };

        # git-permalink-nvim = prev.pkgs.vimUtils.buildVimPlugin {
        #   name = "git-permalink-nvim";
        #   src = /Users/milo/git/git-permalink-nvim;
        # };

        # TODO remove when fzf-lua implementation is merged to NixOS.
        # octo-nvim = prev.pkgs.vimUtils.buildVimPlugin {
        #   name = "octo-nvim";
        #   src = /Users/milo/git/octo.nvim;
        # };
      };

      neovim-custom = final.callPackage ./neovim.nix {};
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
