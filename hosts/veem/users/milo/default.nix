{ config
, pkgs
, ...
}:

{
  home.stateVersion = "22.11";

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
