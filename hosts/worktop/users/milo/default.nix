{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
  xdg = import (common_dir + /home/xdg.nix) { inherit config; };
  direnv = import ./direnv.nix { inherit config; };
in rec {
  inherit xdg;
  imports = [
    (common_dir + /home/default.nix)
  ];

  programs.direnv = direnv;

  home.stateVersion = "21.05";

  programs.git.signing.key = "7291258F2B7C086E";

  home.file = {
    "${xdg.configHome}/tmuxinator/" = {
      recursive = true;
      source = common_dir + "/config/tmuxinator/";
    };
  };

  home.packages = with pkgs; [
    elixir
    git-lfs
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
