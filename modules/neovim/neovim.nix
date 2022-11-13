{ pkgs }:

let
  vimPlugins = pkgs.callPackage ./custom-plugins.nix {};
  customPlugins = with vimPlugins; [
    overrides.nvim-colorizer-lua
    fzf-lua
    heirline-nvim
    hydra-nvim
    nvim-lsp-installer
    nvim-runscript
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
        lua << EOF
          local hl = function(group, opts)
              opts.default = true
              vim.api.nvim_set_hl(0, group, opts)
          end

          -- Misc {{{
          hl('@comment', {link = 'Comment'})
          -- hl('@error', {link = 'Error'})
          hl('@none', {bg = 'NONE', fg = 'NONE'})
          hl('@preproc', {link = 'PreProc'})
          hl('@define', {link = 'Define'})
          hl('@operator', {link = 'Operator'})
          -- }}}

          -- Punctuation {{{
          hl('@punctuation.delimiter', {link = 'Delimiter'})
          hl('@punctuation.bracket', {link = 'Delimiter'})
          hl('@punctuation.special', {link = 'Delimiter'})
          -- }}}

          -- Literals {{{
          hl('@string', {link = 'String'})
          hl('@string.regex', {link = 'String'})
          hl('@string.escape', {link = 'SpecialChar'})
          hl('@string.special', {link = 'SpecialChar'})

          hl('@character', {link = 'Character'})
          hl('@character.special', {link = 'SpecialChar'})

          hl('@boolean', {link = 'Boolean'})
          hl('@number', {link = 'Number'})
          hl('@float', {link = 'Float'})
          -- }}}

          -- Functions {{{
          hl('@function', {link = 'Function'})
          hl('@function.call', {link = 'Function'})
          hl('@function.builtin', {link = 'Special'})
          hl('@function.macro', {link = 'Macro'})

          hl('@method', {link = 'Function'})
          hl('@method.call', {link = 'Function'})

          hl('@constructor', {link = 'Special'})
          hl('@parameter', {link = 'Identifier'})
          -- }}}

          -- Keywords {{{
          hl('@keyword', {link = 'Keyword'})
          hl('@keyword.function', {link = 'Keyword'})
          hl('@keyword.operator', {link = 'Keyword'})
          hl('@keyword.return', {link = 'Keyword'})

          hl('@conditional', {link = 'Conditional'})
          hl('@repeat', {link = 'Repeat'})
          hl('@debug', {link = 'Debug'})
          hl('@label', {link = 'Label'})
          hl('@include', {link = 'Include'})
          hl('@exception', {link = 'Exception'})
          -- }}}

          -- Types {{{
          hl('@type', {link = 'Type'})
          hl('@type.builtin', {link = 'Type'})
          hl('@type.qualifier', {link = 'Type'})
          hl('@type.definition', {link = 'Typedef'})

          hl('@storageclass', {link = 'StorageClass'})
          hl('@attribute', {link = 'PreProc'})
          hl('@field', {link = 'Identifier'})
          hl('@property', {link = 'Identifier'})
          -- }}}

          -- Identifiers {{{
          hl('@variable', {link = 'Normal'})
          hl('@variable.builtin', {link = 'Special'})

          hl('@constant', {link = 'Constant'})
          hl('@constant.builtin', {link = 'Special'})
          hl('@constant.macro', {link = 'Define'})

          hl('@namespace', {link = 'Include'})
          hl('@symbol', {link = 'Identifier'})
          -- }}}

          -- Text {{{
          hl('@text', {link = 'Normal'})
          hl('@text.strong', {bold = true})
          hl('@text.emphasis', {italic = true})
          hl('@text.underline', {underline = true})
          hl('@text.strike', {strikethrough = true})
          hl('@text.title', {link = 'Title'})
          hl('@text.literal', {link = 'String'})
          hl('@text.uri', {link = 'Underlined'})
          hl('@text.math', {link = 'Special'})
          hl('@text.environment', {link = 'Macro'})
          hl('@text.environment.name', {link = 'Type'})
          hl('@text.reference', {link = 'Constant'})

          hl('@text.todo', {link = 'Todo'})
          hl('@text.note', {link = 'SpecialComment'})
          hl('@text.warning', {link = 'WarningMsg'})
          hl('@text.danger', {link = 'ErrorMsg'})
          -- }}}

          -- Tags {{{
          hl('@tag', {link = 'Tag'})
          hl('@tag.attribute', {link = 'Identifier'})
          hl('@tag.delimiter', {link = 'Delimiter'})
          -- }}}
        EOF

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
          -- denols = { "${pkgs.deno}/bin/deno", "lsp" },
          elixirls = { "${pkgs.elixir_ls}/bin/elixir-ls" },
          eslint = {
            "${pkgs.vscode-extensions.dbaeumer.vscode-eslint}/bin/eslint",
            "--stdio",
          },
          rnix = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
          sumneko_lua = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
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

        -- Add the config directory to the start of the rtp
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
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp_luasnip
          comment-nvim
          fidget-nvim
          gitsigns-nvim
          lspkind-nvim
          luasnip
          mini-nvim
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
    /* vimdiffAlias = true; */

    /* defaultEditor = true; */

    withNodeJs = true;
    withRuby = false;
  }
