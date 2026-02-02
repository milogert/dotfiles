{ config, pkgs, ... }:

let
  common_dir = ../../_common;
in
{
  home.packages = with pkgs; [
    imlib2
    ranger
    w3m
  ];

  home.file = {
    "${config.xdg.configHome}/ranger/" = {
      recursive = true;
      source = common_dir + "/config/ranger/";
    };
  };
}
