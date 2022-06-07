{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in {
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/types/headless.nix)
  ];

  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    nodejs
  ];
}
