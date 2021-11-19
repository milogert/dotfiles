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

    extraConfig = builtins.readFile ./init.vim;

    plugins = with vimPlugins; [
      fzf-vim
      plenary-nvim
      srcery-vim
      telescope-fzf-native-nvim
      telescope-nvim
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
      vim-startuptime
      vim-surround
      vim-terraform
      vim-tmux-navigator
      vim-unimpaired
      vimux

      # Built in LSP.
      nvim-lspconfig
      nvim-lsp-installer
      lspkind-nvim
      lsp-status-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      LuaSnip

      # Custom
      # alpha-nvim
      copilot-vim
      impatient-nvim
      nui-nvim
      nvim-treesitter
      package-info-nvim
      persistence-nvim
      vim-arpeggio
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = false;
  };

  home.activation.setVimDirs =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.xdg.dataHome}/nvim/backup/
      mkdir -p ${config.xdg.dataHome}/nvim/swap/
      mkdir -p ${config.xdg.dataHome}/nvim/undo/
    '';
}
