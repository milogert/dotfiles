
{ config, pkgs, ... }:

let
  hostPort = "5055";
  containerPort = hostPort;
  image = "sctx/overseerr";
in {
  virtualisation.oci-containers.containers.overseerr = {
    image = image;
    ports = ["${hostPort}:${containerPort}"];
    volumes = [
      "${config.users.users.media.home}/config/overseerr:/app/config"
    ];
    environment = {
      PUID = builtins.toString config.users.users.media.uid;
      PGID = builtins.toString config.users.groups.media.gid;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.overseerr = {
      entryPoints = [ "websecure" ];
      rule = "Host(`overseerr.milogert.com`)";
      service = "overseerr";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "overseerr.milogert.com"; } ];
      };
    };

    services.overseerr.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}

