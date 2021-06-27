{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
  xdg_common = import (common_dir + /home/xdg.nix) { inherit config; };
in rec {
  xdg = {
    configFile = {
      ripasso = {
        source = ./config/ripasso;
        target = "ripasso";
        recursive = true;
      };

      tmuxinator = {
        source = common_dir + "/config/tmuxinator/";
        target = "tmuxinator";
        recursive = true;
      };
    };
  } // xdg_common;

  imports = [
    (common_dir + /home/default.nix)
    ./sway.nix
    ./waybar.nix
    ./desktop.nix
  ];

  home.stateVersion = "21.05";

  programs.git.signing.key = "7291258F2B7C086E";

  home.packages = with pkgs; [
    calibre
    cargo
    discord
    elixir
    joplin-desktop
    nodejs
    ripasso-cursive
    spotify
    wyvern
    yarn
  ];

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} init.author.name "Milo Gertjejansen"
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
