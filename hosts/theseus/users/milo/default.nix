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
    brave
    calibre
    cargo
    cockatrice
    discord
    insomnia
    nodejs
    ranger
    spotify
    /* spotify-tui */
    /* wyvern */
    yarn
  ];
}
