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
    qtpass
    wyvern
    yarn
  ];
}
