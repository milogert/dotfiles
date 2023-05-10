{ config
, pkgs
, ...
}:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    calibre
    cargo
    cider
    discord
    insomnia
    qtpass
    wyvern
    yarn
  ];
}
