{ pkgs, ... }:

{
  services.tautulli.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    routers.tautulli = {
      entryPoints = [ "websecure" ];
      rule = "Host(`tautulli.milogert.com`)";
      service = "tautulli";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "tautulli.milogert.com"; } ];
      };
    };

    services.tautulli.loadBalancer.servers = [ { url = "http://localhost:8181"; } ];
  };
}
