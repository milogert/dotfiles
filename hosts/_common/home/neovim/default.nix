{ pkgs
, config
, ...
}:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix {};
  xdg = import ../xdg.nix { inherit config; };
in rec {
  inherit xdg;
  home.file = {
    "${xdg.configHome}/nvim/" = {
      recursive = true;
      source = ../../config/nvim + "/";
    };
  };

  home.activation.initalizeCoc =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      if [[ -d ${xdg.configHome}/coc/ ]]; then
        echo "!! Skipping Coc.nvim inialization, since ${xdg.configHome}/coc/ already exists"
      else
        rm -rf ${xdg.configHome}/coc/
        mkdir -p ${xdg.configHome}/coc/
        echo $(pwd)
        cp -r ./.dotfiles/hosts/_common/config/coc/* ${xdg.configHome}/coc/
        echo "!! To install all the Coc.nvim extensions run:"
        echo "    pushd ~/.config/coc/extensions; npm install; popd"
      fi
  '';

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
      vim-arpeggio
      vim-dirvish
      vim-dirvish-git
      vim-fugitive
      #vim-matchit
      vim-nuuid
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
      any-jump-vim
      vim-airline
      vim-airline-themes

      # Languages
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
