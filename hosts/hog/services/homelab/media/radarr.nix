{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    user = "media";
    group = "media";
    dataDir = "${config.users.users.media.home}/config/radarr";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.radarr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`radarr.milogert.dev`)";
      service = "radarr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "radarr.milogert.dev"; } ];
      };
    };

    services.radarr.loadBalancer.servers = [ { url = "http://localhost:7878"; } ];
  };
}
