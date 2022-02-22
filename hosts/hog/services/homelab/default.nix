{ pkgs, ... }: 

{
  imports = [
    # This always should be enabled.
    ./traefik.nix
    ./heimdall.nix

    #./home-assistant
    ./media
    ./monitoring
    ./tt-rss
  ];
}
