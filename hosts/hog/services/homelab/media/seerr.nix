
{ config, pkgs, ... }:

let
  hostPort = "5055";
  containerPort = hostPort;
  image = "sctx/overseerr";
in {
  services.seerr.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    routers.seerr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`seerr.milogert.com`)";
      service = "seerr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "seerr.milogert.com"; } ];
      };
    };

    services.seerr.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}

