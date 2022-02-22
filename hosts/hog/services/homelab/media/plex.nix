{ pkgs, ... }:

{
  services.plex = {
    enable = true;
    package = pkgs.plexPass;
    openFirewall = true;
  };

  users.users.plex.extraGroups = [ "render" "nzbget" ];

  environment.systemPackages = with pkgs; [
    # libav
    # libva
    # libva-utils
    radeontop
  ];

  services.traefik.dynamicConfigOptions.http = {
    routers.plex = {
      entryPoints = [ "websecure" ];
      rule = "Host(`plex.milogert.com`)";
      service = "plex";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "plex.milogert.com"; } ];
      };
    };

    services.plex.loadBalancer.servers = [ { url = "http://localhost:32400"; } ];
  };
}
