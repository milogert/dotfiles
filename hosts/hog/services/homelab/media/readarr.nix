{ config, pkgs, ... }:

let
  servicePort = "8787";
  externalPort = servicePort;
  image = "ghcr.io/hotio/readarr:pr-a78ffba";
in {
  virtualisation.oci-containers.containers.readarr = {
    inherit image;
    ports = ["${servicePort}:${externalPort}"];
    volumes = [
      "${config.users.users.media.home}/config/readarr:/config"
      "/mnt/download-stream-cache/downloads/dst/Books:/downloads"
      "/mnt/media/Books:/library"
    ];
    environment = {
      PUID = builtins.toString config.users.users.media.uid;
      PGID = builtins.toString config.users.groups.media.gid;
    };
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

    services.readarr.loadBalancer.servers = [ { url = "http://localhost:${servicePort}"; } ];
  };
}

