{ config
, pkgs
, ...
}:

let
  home_dir = "${config.home.homeDirectory}";
  common_dir = ../../../_common;
in rec {
  xdg = import (common_dir + "/home/xdg.nix") { inherit config; };

  imports = [
    (common_dir + /home/git)
    (common_dir + /home/neovim)
    ((common_dir + "/home/zsh") { inherit xdg; })
  ];

  home.stateVersion = "21.05";

  #programs.git.signing.key = "696FAC60B36CA0D3";

  home.file = {
    #".psqlrc".source = common_dir + "/conf/.psqlrc";
    #".ripgreprc".source = common_dir + "/conf/.ripgreprc";
    "${xdg.configHome}/tmuxinator/" = {
      recursive = true;
      source = common_dir + "/config/tmuxinator/";
    };
    "${xdg.configHome}/alacritty/" = {
      recursive = true;
      source = common_dir + "/config/alacritty/";
    };
    "${xdg.configHome}/starship.toml".source = common_dir + "/config/starship.toml";
    "${xdg.configHome}/bat/" = {
      recursive = true;
      source = common_dir + "/config/bat/";
    };
    #"${xdg.configHome}/git/ignore".source = common_dir + "/conf/.gitignore";
  };

  home.packages = with pkgs; [
    #bashcards
    elixir
    git-lfs
    #haskellPackages.pandoc
    #haskellPackages.patat
    nodejs-14_x
    ruby
    (yarn.override { nodejs = nodejs-14_x; })
  ];

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs-16_x}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} init.author.name "Milo Gertjejanse"
        ${npmSet} init.author.email "milo@milogert.com"
        ${npmSet} init.author.url "https://milogert.com"
        ${npmSet} init.license "MIT"
        ${npmSet} init.version "0.0.1"
      '';

  home.activation.setVimDirs =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${xdg.dataHome}/nvim/backup/
      mkdir -p ${xdg.dataHome}/nvim/swap/
      mkdir -p ${xdg.dataHome}/nvim/undo/
    '';
}
