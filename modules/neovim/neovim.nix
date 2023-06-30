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
        " Set flake directory, controlled by nix.
        let g:flakePackages = '${flakePackageDir}'

        " Set config dir from nix.
        let g:configPath = '${configDir}'

        " Dirvish - override netrw when using Explore, Sexplore, and Vexplore.
        let g:loaded_netrwPlugin = 1
        command! -nargs=? -complete=dir Explore Dirvish <args>
        command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
        command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

        lua << EOF
        vim.g.debuggers = {
          elixir_ls = "${pkgs.elixir_ls}",
        }
        vim.g.ls_locations = {
          -- denols = { "${pkgs.deno}/bin/deno", "lsp" },
          elixirls = { "${pkgs.elixir_ls}/bin/elixir-ls" },
          eslint = {
            "${pkgs.vscode-extensions.dbaeumer.vscode-eslint}/bin/eslint",
            "--stdio",
          },
          rnix = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
          nil_ls = { "${pkgs.nil}/bin/nil" },
          lua_ls = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
          stylua = { "${pkgs.stylua}/bin/stylua" },
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

        -- Add the config directory to the start of the rtp.
        vim.opt.runtimepath:prepend("${configDir}")

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
        ] ++ customPlugins;
      };
    };

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withRuby = false;
  }
