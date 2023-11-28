{ pkgs }:

let
  customPlugins = pkgs.callPackage ./custom-plugins.nix {};

  # This is propogated down to copilot-lua since it needs help finding the
  # proper directory when nix is involved.
  flakePackageDir = "flakePackages";
  configDir = ./config;
in
  pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      customRC = ''
        " Set config dir from nix.
        let g:configPath = '${configDir}'

        lua << EOF
        vim.g.debuggers = {
          elixir_ls = "${pkgs.elixir_ls}",
          vscode_js = {
            adapter = "${customPlugins.nvim-dap-vscode-js}",
            debugger = "${customPlugins.vscode-js-debug}",
          },
        }

        vim.g.ls_installs = {
          cssls = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/",
          denols = "${pkgs.deno}/bin/",
          elixirls = "${pkgs.elixir_ls}/bin/",
          eslint = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/",
          html = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/",
          jsonls = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/",
          lua_ls = "${pkgs.sumneko-lua-language-server}/bin/",
          nil_ls = "${pkgs.nil}/bin/",
          rnix = "${pkgs.rnix-lsp}/bin/",
          stylua = "${pkgs.stylua}/bin/",
          tailwindcss = "${pkgs.vscode-extensions.bradlc.vscode-tailwindcss}/bin/",
          terraformls = "${pkgs.terraform-ls}/bin/",
          tsserver = "${pkgs.nodePackages.typescript-language-server}/bin/",
        }

        vim.g.tsParserPath = vim.fn.stdpath("data") .. "/site"
        vim.opt.runtimepath:prepend(vim.g.tsParserPath .. "/parser")
        EOF

        source ${configDir}/main.lua
      '';
      packages.${flakePackageDir} = with pkgs.vimPlugins; {
        start = [
          cmp-buffer
          cmp-calc
          cmp-cmdline
          cmp-git
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-nvim-lua
          cmp-path
          cmp_luasnip
          comment-nvim
          copilot-cmp
          copilot-lua
          elixir-tools-nvim
          fidget-nvim
          fzf-lua
          gitsigns-nvim
          heirline-nvim
          hydra-nvim
          lspkind-nvim
          luasnip
          mason-lspconfig-nvim
          mason-nvim
          mini-nvim
          nui-nvim
          null-ls-nvim
          nvim-cmp
          nvim-colorizer-lua
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-lspconfig
          nvim-treesitter
          nvim-treesitter-textobjects
          nvim-web-devicons
          octo-nvim
          package-info-nvim
          persistence-nvim
          plenary-nvim
          srcery-vim
          vim-abolish
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
        ] ++ customPlugins.list;
      };
    };

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withRuby = false;
  }
