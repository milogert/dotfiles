{ config, pkgs, ... }:

let
  service = "kosync";
  hostPort = "17200";
  containerPort = hostPort;
  image = "koreader/kosync";
  configPrefix = "${config.users.users.media.home}/config/${service}";
in {
  virtualisation.oci-containers.containers.${service} = {
    image = image;
    ports = ["${hostPort}:${containerPort}"];
    volumes = [
      "${configPrefix}/logs/app:/app/koreader-sync-server/logs"
      "${configPrefix}/logs/redis:/var/log/redis"
      "${configPrefix}/data/redis:/var/lib/redis"
    ];
    # environment = {
    #   PUID = builtins.toString config.users.users.media.uid;
    #   PGID = builtins.toString config.users.groups.media.gid;
    # };
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
