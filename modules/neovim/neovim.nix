{ pkgs }:

let
  vimPlugins = with pkgs.vimPlugins; [
    blink-cmp
    blink-cmp-git
    blink-compat
    comment-nvim # :help commenting, consider removing this later.
    dressing-nvim
    elixir-tools-nvim
    fidget-nvim
    friendly-snippets
    fzf-lsp-nvim
    fzf-lua
    gitsigns-nvim
    heirline-nvim
    hotpot-nvim
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
    nvim-nio
    nvim-treesitter-textobjects
    # nvim-treesitter-textsubjects
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.awk
      p.bash
      p.c
      p.c_sharp
      p.cmake
      p.comment
      p.commonlisp
      p.cpp
      p.css
      p.csv
      p.desktop
      p.devicetree
      p.diff
      p.dockerfile
      p.dot
      p.editorconfig
      p.eex
      p.elixir
      p.elm
      p.erlang
      p.func
      p.git_config
      p.git_rebase
      p.gitattributes
      p.gitcommit
      p.gitignore
      p.gleam
      p.go
      p.gpg
      p.graphql
      p.heex
      p.html
      p.http
      p.hurl
      p.ini
      p.javascript
      p.jq
      p.jsdoc
      p.json
      p.json5
      p.latex
      p.lua
      p.luadoc
      p.make
      p.markdown
      p.markdown_inline
      p.mermaid
      p.nginx
      p.nix
      p.passwd
      p.php
      p.phpdoc
      p.printf
      p.properties
      p.query
      p.readline
      p.regex
      p.requirements
      p.robots_txt
      p.scss
      p.sql
      p.ssh_config
      p.styled
      p.svelte
      p.sway
      p.terraform
      p.tmux
      p.todotxt
      p.toml
      p.tsx
      p.turtle
      p.twig
      p.typescript
      p.typespec
      p.typoscript
      p.typst
      p.udev
      p.vim
      p.vimdoc
      p.xml
      p.yaml
      p.zsh
    ]))
    nvim-web-devicons
    obsidian-nvim
    octo-nvim
    oil-nvim
    other-nvim
    package-info-nvim
    persistence-nvim
    # sqlite-lua
    srcery-vim
    tssorter-nvim
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
  customPlugins = pkgs.callPackage ./custom-plugins.nix { };
  configDir = ./config;
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  luaRcContent = ''
    vim.opt.runtimepath:prepend('${configDir}')
    require('milogert.main').setup({
      nix = true,

      debuggers = {
        vscode_js = {
          adapter = "${customPlugins.nvim-dap-vscode-js}",
          debugger = "${pkgs.vscode-js-debug}",
        },
      },

      ls_cmds = {
        -- biome = { "${pkgs.vscode-extensions.biomejs.biome}/bin/biome", "start" },
        biome = { "node_modules/.bin/biome", "lsp-proxy" },
        cssls = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
        elixirls = { "${pkgs.elixir-ls}/bin/elixir-ls" },
        html = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
        jsonls = { "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
        lua_ls = { "${pkgs.lua-language-server}/bin/lua-language-server" },
        nil_ls = { "${pkgs.nil}/bin/nil" },
        tailwindcss = { "${pkgs.vscode-extensions.bradlc.vscode-tailwindcss}/bin/tailwindcss-language-server", "--stdio", },
        terraformls = { "${pkgs.terraform-ls}/bin/terraform-ls", "serve" },
        texlab = { "${pkgs.texlab}/bin/texlab" },
        tsgo = { "${pkgs.typescript-go}/bin/tsgo", "--lsp", "--stdio", },
      },

      formatters = {
        lua = { "${pkgs.stylua}/bin/stylua" },
        sql = { "${pkgs.pgformatter}/bin/pg_format" },
      },
    })
  '';

  plugins = vimPlugins ++ customPlugins.list;

  viAlias = true;
  vimAlias = true;

  withNodeJs = true;
  withRuby = false;
}
