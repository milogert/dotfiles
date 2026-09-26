{ config, pkgs, ... }:

let
  hostPort = "8787";
in {
  services.readarr = {
    enable = true;
    user = "media";
    group = "media";
    dataDir = "${config.users.users.media.home}/config/readarr";
    settings.server.port = 8787;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.readarr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`readarr.milogert.dev`)";
      service = "readarr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "readarr.milogert.dev"; } ];
      };
    };

    services.readarr.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}

