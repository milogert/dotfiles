{ pkgs
, config
, ...
}:

let
  vimPlugins = pkgs.callPackage ./custom-plugins.nix {};
  customPlugins = with vimPlugins; [
      /* alpha-nvim            # Custom */
      /* impatient-nvim        # Custom */
      copilot-cmp           # Custom
      copilot-lua           # Custom
      fzf-lua               # Custom
      heirline-nvim         # Custom
      nvim-lsp-installer    # Custom
      octo-nvim             # Custom
      persistence-nvim      # Custom
      vim-arpeggio          # Custom
  ];
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
      let g:do_filetype_lua = 1
      let g:did_load_filetypes = 0

      source ~/.config/nvim/main.lua
    '';

    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = cmp-nvim-lsp;
      }

      /* nvim-gps */
      /* which-key-nvim */
      cmp-buffer
      cmp-calc
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp_luasnip
      fidget-nvim
      gitsigns-nvim
      lsp-status-nvim
      lspkind-nvim
      luasnip
      nui-nvim
      null-ls-nvim
      nvim-cmp
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
    ] ++ customPlugins;

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
