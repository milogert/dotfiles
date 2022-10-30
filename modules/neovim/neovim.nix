{ pkgs }:

let
  vimPlugins = pkgs.callPackage ./custom-plugins.nix {};
  customPlugins = with vimPlugins; [
    /* alpha-nvim */
    /* impatient-nvim */
    /* copilot-cmp */
    /* copilot-lua */
    fzf-lua
    heirline-nvim
    nvim-dev-container
    nvim-docker
    nvim-lsp-installer
    nvim-navic
    nvim-remote-containers
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
        " Only load lua ft plugins
        "let g:do_filetype_lua = 1
        "let g:did_load_filetypes = 0

        " Set flake directory, controlled by nix
        let g:flakePackages = '${flakePackageDir}'

        " Set config dir from nix
        let g:configPath = '${configDir}'

        " Disable netrw
        "let g:loaded_netrw = 1
        "let g:loaded_netrwPlugin = 1

        lua << EOF
        vim.g.debuggers = {
          elixir_ls = "${pkgs.elixir_ls}",
        }
        vim.g.ls_locations = {
          elixirls = { "${pkgs.elixir_ls}/bin/elixir-ls" },
          eslint = {
            "${pkgs.vscode-extensions.dbaeumer.vscode-eslint}/bin/eslint",
            "--stdio",
          },
          rnix = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
          sumneko_ls = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
          tailwindcss = {
            "${pkgs.vscode-extensions.bradlc.vscode-tailwindcss}/bin/tailwindcss-language-server",
            "--stdio",
          },
          terraformls = {
            "${pkgs.terraform-ls}/bin/terraform-ls", "serve"
          },
          tsserver = {
            "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server" ,
            "--stdio",
            "--tsserver-path",
            "tsserver",
          },
        }
        EOF

        " Add the config directory to the start of the rtp
        set runtimepath^=${configDir}

        source ${configDir}/main.lua
      '';
      packages.${flakePackageDir} = with pkgs.vimPlugins; {
        start = [
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
          nvim-colorizer-lua
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
          vim-dadbod
          vim-dadbod-ui
          vim-dirvish
          vim-dirvish-git
          vim-dispatch
          vim-dispatch-neovim
          vim-elixir
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
