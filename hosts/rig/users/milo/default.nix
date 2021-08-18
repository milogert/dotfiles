{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
  xdg = import (common_dir + /home/xdg.nix) { inherit config; };
in rec {
  inherit xdg;
  imports = [
    (common_dir + /home/default-headless.nix)
  ];

  home.stateVersion = "21.05";

  home.file = {
    "${xdg.configHome}/tmuxinator/" = {
      recursive = true;
      source = common_dir + "/config/tmuxinator/";
    };
  };

  home.packages = with pkgs; [
    nodejs
  ];

  home.activation.setVimDirs =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${xdg.dataHome}/nvim/backup/
      mkdir -p ${xdg.dataHome}/nvim/swap/
      mkdir -p ${xdg.dataHome}/nvim/undo/
    '';
}
