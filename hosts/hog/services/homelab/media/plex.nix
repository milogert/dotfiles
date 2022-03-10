{ config, pkgs, ... }:

{
  services.plex = {
    enable = true;
    package = pkgs.plexPass;
    openFirewall = true;
    user = "media";
    group = "media";
    dataDir = "${config.users.users.media.home}/config/plex";
  };

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
