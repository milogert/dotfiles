{
  inputs,
}:
let
  fromFlakes = {
    # Left here as an example.
    # expert = inputs.expert.packages.${system}.default;
  };

  # Left here as an example.
  # overlayPkgs = (
  #   final: prev:
  #   {
  #     utillinux = prev.util-linux;
  #     zen-browser = inputs.zen-browser.packages.${system}.default;
  #   }
  #   // fromFlakes
  # );
in
final: prev:
{
  wrapNeovim = prev.wrapNeovim.overrideAttrs (old: {
  });

  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    buildInputs =
      old.buildInputs
      ++ (with prev.pkgs; [
        # node-debug2
        elixir-ls
        nil
        typescript
        typescript-language-server
        statix
        sqlfluff
        stylua
        lua-language-server
        terraform-ls
        texlab
        vscode-extensions.bradlc.vscode-tailwindcss
      ]);
  });

  vimPlugins = prev.vimPlugins // {
    nvim-colorizer-lua = prev.vimPlugins.nvim-colorizer-lua.overrideAttrs (old: {
      version = "2026-04-07";
      src = prev.pkgs.fetchFromGitHub {
        owner = "catgoose";
        repo = "nvim-colorizer.lua";
        rev = "5cfe7fffbd01e17b3c1e14af85d5febdef88bd8c";
        sha256 = "0x5lnm1hjrqdklr2fbjnwy1gyf40l9allqr8il74p4mcp1lwdv9r";
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

    fzf-lua = prev.vimPlugins.fzf-lua.overrideAttrs (old: {
      src = prev.pkgs.fetchFromGitHub {
        owner = "ibhagwan";
        repo = "fzf-lua";
        rev = "a8458b79a957a6e3e217d84106a0fd4b9470ff4c";
        sha256 = "0wswrbfjjyid1zgqmjcxkl7mljsmlayzkfnkpc3zy82ry8li0nis";
      };
    });

    obsidian-nvim = prev.vimPlugins.obsidian-nvim.overrideAttrs (old: {
      src = prev.pkgs.fetchFromGitHub {
        owner = "obsidian-nvim";
        repo = "obsidian.nvim";
        rev = "1a1a475846a4cfa3cfedde1c59141d99b6212951";
        sha256 = "1ianli3dqpgwiyfhbfxs866bxsqn4m0c09nd4s3048sj6ay6g6pj";
      };
    });

    nvim-treesitter-textsubjects = prev.vimPlugins.nvim-treesitter-textsubjects.overrideAttrs (old: {
      src = prev.pkgs.fetchFromGitHub {
        owner = "RRethy";
        repo = "nvim-treesitter-textsubjects";
        rev = "9e3edd38e44c8f3af5634c5e30a33ebd79227f11";
        sha256 = "05p3z792ln18rfwv3p6x92kfjyzni58x77m8hwxmdm706s1nmcbn";
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
    #   doCheck = false;
    # };
  };

  neovim-custom = final.callPackage ./neovim.nix { };
}
// fromFlakes
