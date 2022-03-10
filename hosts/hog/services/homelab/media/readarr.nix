{ config, pkgs, ... }:

let
  servicePort = "8787";
  externalPort = servicePort;
  image = "ghcr.io/hotio/readarr:pr-a78ffba";
in {
  virtualisation.oci-containers.containers.readarr = {
    image = image;
    ports = ["${servicePort}:${externalPort}"];
    volumes = [
      "${config.users.users.media.home}/config/readarr:/config"
      "${config.users.users.media.home}/downloads/dst/Books:/downloads"
      "${config.users.users.media.home}/content/books:/library"
    ];
    environment = {
      # PUID = "1000";
      # PGID = "1000";
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

