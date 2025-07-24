{ pkgs }:

let
  vimPlugins = with pkgs.vimPlugins; [
    blink-cmp
    blink-cmp-git
    blink-compat
    cmp-buffer
    cmp-calc
    cmp-cmdline
    cmp-git
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path
    comment-nvim # :help commenting, consider removing this later.
    dressing-nvim
    elixir-tools-nvim
    fidget-nvim
    friendly-snippets
    fzf-lsp-nvim
    fzf-lua
    gitsigns-nvim
    heirline-nvim
    hydra-nvim
    lazy-nvim
    lspkind-nvim
    mason-lspconfig-nvim
    mason-nvim
    none-ls-nvim
    nui-nvim
    nvim-cmp
    nvim-colorizer-lua
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-lint
    nvim-nio
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    octo-nvim
    oil-nvim
    other-nvim
    package-info-nvim
    persistence-nvim
    plenary-nvim
    srcery-vim
    supermaven-nvim
    typescript-tools-nvim
    vim-abolish
    vim-dadbod
    vim-dadbod-completion
    vim-dadbod-ui
    vim-dispatch
    vim-dispatch-neovim
    vim-elixir
    vim-fugitive
    vim-repeat
    vim-startuptime
    vim-surround
    vim-tmux-navigator
    vim-unimpaired
    vimux
  ];
  customPlugins = pkgs.callPackage ./custom-plugins.nix {};
  configDir = ./config;
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    luaRcContent = ''
      vim.opt.runtimepath:prepend('${configDir}')

      require('milogert.main').setup({
        nix = true,

        debuggers = {
          elixir_ls = "${pkgs.elixir_ls}/bin/.elixir-debugger-wrapped",
          vscode_js = {
            adapter = "${customPlugins.nvim-dap-vscode-js}",
            debugger = "${pkgs.vscode-js-debug}",
          },
        },

        ls_cmds = {
          cssls = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
          elixirls = { "${pkgs.elixir_ls}/bin/.elixir-ls-wrapped" },
          eslint = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" },
          html = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
          jsonls = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
          lua_ls = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
          nil_ls = { "${pkgs.nil}/bin/nil" },
          stylua = { "${pkgs.stylua}/bin/stylua" },
          tailwindcss = { "${pkgs.vscode-extensions.bradlc.vscode-tailwindcss}/bin/tailwindcss-language-server", "--stdio", },
          terraformls = { "${pkgs.terraform-ls}/bin/terraform-ls", "serve" },
          texlab = { "${pkgs.texlab}/bin/texlab" },
          ts_ls = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio", },
        },
      })
    '';

    plugins = vimPlugins ++ customPlugins.list;

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withRuby = false;
  }
