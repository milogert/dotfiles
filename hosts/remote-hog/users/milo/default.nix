{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
  xdg = import (common_dir + /home/xdg.nix) { inherit config; };
in {
  # imports = [
  #   (common_dir + /home/types/headless.nix)
  # ];

  home.stateVersion = "21.05";
}
