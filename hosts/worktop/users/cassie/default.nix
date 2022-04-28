{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in rec {
  imports = [
    (common_dir + /home/default.nix)
    /* (common_dir + /home/direnv.nix) */
    (common_dir + /home/types/desktop.nix)
  ];

  home.stateVersion = "21.05";

  home.packages = with pkgs; [
  ];
}
