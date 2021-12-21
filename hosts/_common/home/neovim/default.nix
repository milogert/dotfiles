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
      nvim-web-devicons
      plenary-nvim
      srcery-vim
      vim-airline
      vim-airline-themes
      vim-commentary
      vim-dirvish
      vim-dirvish-git
      vim-fugitive
      vim-obsession
      vim-signify
      vim-startuptime
      vim-surround
      vim-tmux-navigator
      vim-unimpaired
      vimux
      which-key-nvim

      # Built in LSP.
      nvim-lspconfig
      nvim-lsp-installer
      lspkind-nvim
      lsp-status-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip

      # Custom
      # alpha-nvim
      copilot-vim
      impatient-nvim
      nui-nvim
      nvim-treesitter
      octo-nvim
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
