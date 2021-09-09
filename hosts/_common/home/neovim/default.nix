{ pkgs
, config
, ...
}:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix {};
  xdg = import ../xdg.nix { inherit config; };
  cocConfig = ../../config/coc + "/";

in rec {
  inherit xdg;
  home.packages = with pkgs; [tree-sitter];
  home.file = {
    "${xdg.configHome}/nvim/" = {
      recursive = true;
      source = ../../config/nvim + "/";
    };
  };

  programs.neovim = {
    enable = true;

    coc = {
      enable = true;

      settings = {
        "diagnostic.enableMessage" = "never";
        "diagnostic.virtualText" = true;
        "diagnostic.virtualTextCurrentLineOnly" = true;
        "codelens.enable" = true;
        "eslint.nodePath" = "./node_modules";
        "eslint.autoFixOnSave"= true;
        "eslint.packageManager"= "yarn";
        "eslint.debug"= false;
        "eslint.lintTask.options" = ["." "--ext" ".jsx,.js"];
        languageserver = {
          nix = {
            "command" = "rnix-lsp";
            "filetypes" = [ "nix" ];
          };
        };
      };
    };

    extraConfig = builtins.readFile ./init.vim;

    plugins = with vimPlugins; [
      # Tooling
      # coc-nvim
      fzf-vim
      nvim-treesitter
      vim-arpeggio
      vim-commentary
      vim-dirvish
      vim-dirvish-git
      vim-fugitive
      vim-nuuid
      vim-obsession
      vim-signify
      vim-surround
      vim-tmux-navigator
      vim-unimpaired
      vimux
      # wilder-nvim
      persistence-nvim

      # Themes
      srcery-vim

      # UI
      # any-jump-vim
      vim-airline
      vim-airline-themes

      # Languages
      elm-vim
      rust-vim
      vim-coffee-script
      vim-elixir
      vim-elm-syntax
      vim-graphql
      vim-javascript
      vim-jsx-pretty
      vim-nix
      vim-pug
      vim-terraform
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
