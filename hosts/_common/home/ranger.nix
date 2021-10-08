{ config, pkgs, ... }: 

let
  common_dir = ../../_common;
  xdg = import ./xdg.nix { inherit config; };
in rec {
  home.packages = with pkgs; [
    imlib2
    ranger
    w3m
  ];

  home.file = {
    "${xdg.configHome}/ranger/" = {
      recursive = true;
      source = common_dir + "/config/ranger/";
    };
  };
}
