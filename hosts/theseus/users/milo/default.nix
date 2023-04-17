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

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd;

    settings.global = {
      username = "milo@milogert.com";
      password_cmd = "jq -r \".spotifyd.password\" /etc/nixos/secrets.nix"; 
      device_name = "theseus";
    };
  };

  home.packages = with pkgs; [
    calibre
    cargo
    cider
    discord
    insomnia
    qtpass
    spotify
    spotify-tui
    wyvern
    yarn
  ];
}
