{ pkgs
, config
, ...
}:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix {};
  cocConfig = ../../config/coc + "/";
in rec {
  home.packages = with pkgs; [tree-sitter];

  home.file = {
    "${config.xdg.configHome}/nvim/" = {
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
        "codeLens.enable" = true;
        "eslint.nodePath" = "./node_modules";
        "eslint.autoFixOnSave"= true;
        "eslint.packageManager"= "yarn";
        "eslint.debug"= false;
        "eslint.lintTask.options" = ["." "--ext" ".jsx,.js"];
        "explorer.file.showHiddenFiles" = true;
        languageserver = {
          nix = {
            command = "rnix-lsp";
            filetypes = [ "nix" ];
          };
          terraform = {
            command = "terraform-lsp";
            filetypes = ["terraform"];
            initializationOptions = {};
          };
        };
        "suggest.enablePreselect" = true;
      };
    };

    extraConfig = builtins.readFile ./init.vim;

    plugins = with vimPlugins; [
      coc-nvim
      elm-vim
      fzf-vim
      rust-vim
      srcery-vim
      vim-airline
      vim-airline-themes
      vim-coffee-script
      vim-commentary
      vim-dirvish
      vim-dirvish-git
      vim-elixir
      vim-elm-syntax
      vim-fugitive
      vim-graphql
      vim-javascript
      vim-jsx-pretty
      vim-nix
      vim-obsession
      vim-pug
      vim-signify
      vim-surround
      vim-terraform
      vim-tmux-navigator
      vim-unimpaired
      vimux

      # Custom
      # alpha-nvim
      # any-jump-vim
      copilot-vim
      nui-nvim
      nvim-treesitter
      package-info-nvim
      persistence-nvim
      vim-arpeggio
      vim-nuuid
      # wilder-nvim
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.activation.setVimDirs =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.xdg.dataHome}/nvim/backup/
      mkdir -p ${config.xdg.dataHome}/nvim/swap/
      mkdir -p ${config.xdg.dataHome}/nvim/undo/
    '';
}
