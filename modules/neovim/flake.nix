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
        # art-nvim = old.pkgs.vimUtils.buildVimPlugin {
        #   name = "art-nvim";
        #   src = /Users/milo/projects/art-nvim;
        # };

        # git-permalink-nvim = old.pkgs.vimUtils.buildVimPlugin {
        #   name = "git-permalink-nvim";
        #   src = /Users/milo/git/git-permalink-nvim;
        # };

        # TODO remove when fzf-lua implementation is merged to NixOS.
        octo-nvim = prev.vimPlugins.octo-nvim.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "pwntester";
            repo = "octo.nvim";
            rev = "22328c578bc013fa4b0cef3d00af35efe0c0f256";
            sha256 = "08ik7v5gfpy52z09wbx1rbdhcz1v1c41i5l9kx4p25rxw8g9cl8v";
          };
        });
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
