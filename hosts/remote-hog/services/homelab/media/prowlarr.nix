
{ config, pkgs, ... }:

{
  services.prowlarr = {
    enable = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.prowlarr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`prowlarr.milogert.dev`)";
      service = "prowlarr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "prowlarr.milogert.dev"; } ];
      };
    };

    services.prowlarr.loadBalancer.servers = [ { url = "http://localhost:9696"; } ];
  };
}
