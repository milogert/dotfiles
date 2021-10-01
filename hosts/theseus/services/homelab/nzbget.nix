{ pkgs, ... }:

{
  services.nzbget.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    routers.nzbget = {
      entryPoints = [ "websecure" ];
      rule = "Host(`nzbget.milogert.dev`)";
      service = "nzbget";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "nzbget.milogert.dev"; } ];
      };
    };

    services.nzbget.loadBalancer.servers = [ { url = "http://localhost:6789"; } ];
  };
}
