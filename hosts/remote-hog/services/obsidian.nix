{ config, pkgs, ... }:

let
  service = "obsidian";
  hostPort = "17201";
  containerPort = "5984";
  configPrefix = "${config.users.users.media.home}/config/${service}";
in {
  virtualisation.oci-containers.containers.${service} = {
    image = "couchdb:3.3.3";
    ports = ["${hostPort}:${containerPort}"];
    volumes = [
      "${configPrefix}/data:/opt/couchdb/data"
      "${configPrefix}/etc/local.d:/opt/couchdb/etc/local.d"
    ];
    environment = {
      PUID = builtins.toString config.users.users.media.uid;
      PGID = builtins.toString config.users.groups.media.gid;
      TZ = "America/New_York";
    };
    environmentFiles = [
      "/etc/secrets/obsidian.env"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.${service} = {
      inherit service;
      entryPoints = [ "websecure" ];
      rule = "Host(`${service}.milogert.com`)";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "${service}.milogert.com"; } ];
      };
    };

    services.${service}.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}
