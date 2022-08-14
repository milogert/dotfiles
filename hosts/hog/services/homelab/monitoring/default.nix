{ pkgs, ... }: 

{
  imports = [
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
    # ./tautulli.nix

    # Future
    # ./scrutiny.nix # https://github.com/stephenlang/scrutiny
  ];
}
