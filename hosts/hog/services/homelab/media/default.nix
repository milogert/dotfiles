{ pkgs, ... }: 

{
  imports = [
    ./nzbget.nix
    ./nzbhydra2.nix
    ./plex.nix
    ./radarr.nix
    ./readarr.nix
    ./sonarr.nix

    # Future
    # ./overseerr.nix # https://overseerr.dev/
    # ./tdarr.nix # https://tdarr.io/
  ];
}
