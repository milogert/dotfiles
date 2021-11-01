{ pkgs, ... }: 

{
  imports = [
    # This always should be enabled.
    ./traefik.nix

    ./grafana.nix
    # ./jellyfin.nix
    ./heimdall.nix
    ./loki.nix
    ./nzbget.nix
    ./nzbhydra2.nix
    ./plex.nix
    ./prometheus.nix
    ./radarr.nix
    ./sonarr.nix
    # ./tautulli.nix
    ./tt-rss

    # Future
    # ./scrutiny.nix # https://github.com/stephenlang/scrutiny
    # ./overseerr.nix # https://overseerr.dev/
    # ./tdarr.nix # https://tdarr.io/
  ];
}
