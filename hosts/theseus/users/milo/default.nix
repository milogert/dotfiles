{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in rec {
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/direnv.nix)
    (common_dir + /home/types/dekstop.nix)
    ./sway.nix
    ./waybar.nix
    ./desktop.nix
  ];

  home.stateVersion = "21.05";

  programs.git.signing.key = "7291258F2B7C086E";

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
    discord
    elixir
    insomnia
    joplin
    joplin-desktop
    nodejs
    qtpass
    #ripasso-cursive
    spotify
    spotify-tui
    wyvern
    yarn
  ];

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} init.author.name "Milo Gertjejansen"
        ${npmSet} init.author.email "milo@milogert.com"
        ${npmSet} init.author.url "https://milogert.com"
        ${npmSet} init.license "MIT"
        ${npmSet} init.version "0.0.1"
      '';
}
