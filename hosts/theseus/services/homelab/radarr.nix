{ pkgs, ... }:

{
  services.radarr.enable = true;

  users.users.radarr.extraGroups = [ "nzbget" ];

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
