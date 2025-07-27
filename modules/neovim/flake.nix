{
  description = "Milo's custom neovim setup";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs @ { self, nixpkgs }: {
    overlays.default = final: prev: {
      wrapNeovim = prev.wrapNeovim.overrideAttrs(old: {
      });

      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs(old: {
        buildInputs = old.buildInputs ++ (with prev.pkgs; [
          /* node-debug2 */
          /* nodePackages.eslint */
          elixir-ls
          eslint_d
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
        nvim-colorizer-lua = prev.vimPlugins.nvim-colorizer-lua.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "catgoose";
            repo = "nvim-colorizer.lua";
            rev = "943be69156b94fbc96064f4913d653f0c7fb299f";
            sha256 = "sha256-oQJno6j5Z7PwE6ulfgc0nJi5U90xsZO/ALgBCOI4aTk=";
          };
        });

        # Remove when https://github.com/j-hui/fidget.nvim/issues/131 resolves.
        fidget-nvim = prev.vimPlugins.fidget-nvim.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "j-hui";
            repo = "fidget.nvim";
            rev = "90c22e47be057562ee9566bad313ad42d622c1d3";
            sha256 = "1ga6pxz89687km1mwisd4vfl1bpw6gg100v9xcfjks03zc1bywrp";
          };
        });

        dressing-nvim = prev.vimPlugins.dressing-nvim.overrideAttrs (old: {
          src = prev.pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = "dressing.nvim";
            rev = "18e5beb3845f085b6a33c24112b37988f3f93c06";
            sha256 = "0pvkm9s0lg0vlk7qbn1sjf6sis3i3xba1824xml631bg6hahw37l";
          };
        });

        # Dev overlays.
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
