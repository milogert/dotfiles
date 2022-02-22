{ pkgs, ... }:

{
  services.sonarr.enable = true;

  users.users.sonarr.extraGroups = [ "nzbget" ];

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
