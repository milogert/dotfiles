{ pkgs
, config
, ...
}:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix {};
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

    extraConfig = ''
      source ~/.config/nvim/main.lua
    '';

    plugins = with vimPlugins; [
      {
        type = "lua";
        plugin = cmp-nvim-lsp;
      }
      cmp_luasnip
      copilot-vim
      /* fzf-vim */
      gitsigns-nvim
      lsp-status-nvim
      lspkind-nvim
      luasnip
      nui-nvim
      null-ls-nvim
      nvim-cmp
      /* nvim-gps */
      nvim-lspconfig
      nvim-treesitter
      nvim-web-devicons
      package-info-nvim
      plenary-nvim
      srcery-vim
      vim-commentary
      vim-dirvish
      vim-dirvish-git
      vim-fugitive
      vim-obsession
      vim-startuptime
      vim-surround
      vim-tmux-navigator
      vim-unimpaired
      vimux
      /* which-key-nvim */

      # Custom
      /* alpha-nvim */
      fzf-lua
      heirline-nvim
      /* impatient-nvim */
      nvim-lsp-installer
      octo-nvim
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

  xdg.configFile = {
    "nvim/init.generated.lua".text = config.programs.neovim.generatedConfigs.lua;
  };
}
