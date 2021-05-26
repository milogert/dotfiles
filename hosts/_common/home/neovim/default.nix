{ pkgs
, ...
}:

let
  vimPlugins = pkgs.vimPlugins;# // pkgs.callPackage ./custom-plugins.nix {};
  #common_dir = ../../../_common;
in rec {
  home.file = {
    "${xdg.configHome}/nvim/" = {
      recursive = true;
      source = "../../config/nvim/";
    };
    "${xdg.configHome}/coc/" = {
      recursive = true;
      source = "../../config/coc/";
    };
  };

  programs.neovim = {
    enable = true;

    extraConfig = builtins.readFile ./init.vim;

    plugins = with vimPlugins; [
      #vim-sensible
      neovim-sensible

      # Tooling
      coc-nvim
      #fzf
      fzf-vim
      #vim-arpeggio
      vim-dirvish
      vim-dirvish-git
      vim-fugitive
      #vim-matchit
      #vim-nuuid
      vim-obsession
      vim-signify
      vim-surround
      vim-tmux-navigator
      vim-unimpaired
      vimux

      # Themes
      #moonlight-nvim
      #nord-nvim
      #onedark-vim
      srcery-vim

      # UI
      #any-jump.vim
      vim-airline
      vim-airline-themes

      #vim-coloresque

      # Languages
      #vim-go
      elm-vim
      rust-vim
      vim-coffee-script
      vim-elixir
      vim-elm-syntax
      vim-graphql
      vim-javascript
      vim-jsx-pretty
      vim-nix
      vim-pug
      vim-terraform
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
