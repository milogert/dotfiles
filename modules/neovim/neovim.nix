{ pkgs }:

let
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
            debugger = "${customPlugins.vscode-js-debug}",
          },
        },

        ls_cmds = {
          cssls = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
          -- denols = { "${pkgs.deno}/bin/deno", "lsp" },
          elixirls = { "${pkgs.elixir_ls}/bin/.elixir-ls-wrapped" },
          eslint = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" },
          html = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
          jsonls = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
          lua_ls = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
          nil_ls = { "${pkgs.nil}/bin/nil" },
          rnix = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
          stylua = { "${pkgs.stylua}/bin/stylua" },
          tailwindcss = { "${pkgs.vscode-extensions.bradlc.vscode-tailwindcss}/bin/tailwindcss-language-server", "--stdio", },
          terraformls = { "${pkgs.terraform-ls}/bin/terraform-ls", "serve" },
          tsserver = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio", },
        },
      })

    '';
    packpathDirs.myNeovimPackages = with pkgs.vimPlugins; {
      start = [
        cmp-buffer
        cmp-calc
        cmp-cmdline
        cmp-git
        cmp-nvim-lsp
        # cmp-nvim-lsp-signature-help
        cmp-nvim-lua
        cmp-path
        cmp_luasnip
        comment-nvim
        copilot-cmp
        copilot-lua
        elixir-tools-nvim
        fidget-nvim
        friendly-snippets
        fzf-lua
        gitsigns-nvim
        heirline-nvim
        hydra-nvim
        lspkind-nvim
        lspsaga-nvim
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
        (nvim-treesitter.withPlugins (p: [
          p.bash # (maintained)
          p.comment # (maintained)
          p.css # (maintained)
          p.dockerfile # (maintained)
          p.eex # (maintained)
          p.elixir # (maintained)
          p.elm # (NOT maintained, 2022-04-28)
          p.erlang # (maintained)
          p.fennel # (maintained)
          p.gitcommit # (maintained)
          p.go # (maintained)
          p.graphql # (maintained)
          p.haskell # (NOT maintained, 2022-04-28)
          p.hcl # (maintained)
          p.heex # (maintained)
          p.hjson # (maintained)
          p.html # (maintained)
          p.http # (maintained)
          p.java # (maintained)
          p.javascript # (maintained)
          p.jsdoc # (maintained)
          p.jsonc # (maintained)
          p.kotlin # (maintained)
          p.latex # (maintained)
          p.llvm # (maintained)
          p.lua # (maintained)
          p.make # (maintained)
          p.markdown # (NOT maintained, 2022-04-28)
          p.nix # (maintained)
          p.perl # (maintained)
          p.php # (maintained)
          p.pug # (maintained)
          p.python # (maintained)
          p.ql # (maintained)
          p.query # Tree-sitter query language (maintained)
          p.r # (maintained)
          p.regex # (maintained)
          p.rust # (maintained)
          p.scss # (maintained)
          p.todotxt # (experimental, maintained)
          p.toml # (maintained)
          p.tsx # (maintained)
          p.typescript # (maintained)
          p.vim # (maintained)
          p.vimdoc # (maintained)
          p.vue # (maintained)
          p.yaml # (maintained)
        ]))
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

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withRuby = false;
  }
