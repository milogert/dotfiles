{ config, pkgs, ... }:

{
  services.sonarr = {
    enable = true;
    user = "media";
    group = "media";
    dataDir = "${config.users.users.media.home}/config/sonarr";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.sonarr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`sonarr.milogert.dev`)";
      service = "sonarr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "sonarr.milogert.dev"; } ];
      };
    };

    services.sonarr.loadBalancer.servers = [ { url = "http://localhost:8989"; } ];
  };
}
