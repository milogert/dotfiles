{ config
, pkgs
, ...
}:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./desktop.nix
  ];

  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    calibre
    cargo
    cider
    discord
    slumber
    wyvern
    yarn
  ];
}
