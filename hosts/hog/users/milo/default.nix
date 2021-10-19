{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
  xdg = import (common_dir + /home/xdg.nix) { inherit config; };
in rec {
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/types/headless.nix)
  ];

  home.stateVersion = "21.05";

  programs.git.signing.key = "7291258F2B7C086E";

  home.packages = with pkgs; [
    nodejs
  ];
}
