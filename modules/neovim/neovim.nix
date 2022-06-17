{ pkgs }:

let
  vimPlugins = pkgs.callPackage ./custom-plugins.nix {};
  customPlugins = with vimPlugins; [
    /* alpha-nvim */
    /* impatient-nvim */
    copilot-cmp
    copilot-lua
    fzf-lua
    heirline-nvim
    nvim-lsp-installer
    octo-nvim
    persistence-nvim
    vim-arpeggio
    vim-tada
  ];
   /* myNeovimUnwrapped = pkgs.neovim-unwrapped.overrideAttrs (prev: { */
   /*  propagatedBuildInputs = with pkgs; [pkgs.stdenv.cc.cc.lib]; */
  /* }); */

  # This is propogated down to copilot-lua since it needs help finding the
  # proper directory when nix is involved.
  flakePackageDir = "flakePackages";
  configDir = ./config;
in
  pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      customRC = ''
        let g:do_filetype_lua = 1
        let g:did_load_filetypes = 0
        let g:flakePackages = '${flakePackageDir}'
        let g:configPath = '${configDir}'

        set runtimepath^=${configDir}
        source ${configDir}/main.lua
      '';
      packages.${flakePackageDir} = with pkgs.vimPlugins; {
        start = [
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
          lspkind-nvim
          luasnip
          nui-nvim
          null-ls-nvim
          nvim-cmp
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
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
      };
    };

    viAlias = true;
    vimAlias = true;
    /* vimdiffAlias = true; */

    /* defaultEditor = true; */

    withNodeJs = true;
    withRuby = false;
  }
