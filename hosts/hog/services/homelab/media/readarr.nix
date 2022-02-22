{ pkgs, ... }:

let
  userGroupName = "readarr";
  userGroupId = 276;
  servicePort = "8787";
  externalPort = servicePort;
  image = "ghcr.io/hotio/readarr:pr-a78ffba";
in {
  users.users.readarr = {
    home = "/var/lib/readarr";
    createHome = true;
    group = "readarr";
    extraGroups = [ "nzbget" ];
    uid = userGroupId;
    isSystemUser = true;
  };

  users.groups.readarr = {
    members = [ "readarr" ];
    gid = userGroupId;
  };


  virtualisation.oci-containers.containers."${userGroupName}" = {
    image = image;
    ports = ["${servicePort}:${externalPort}"];
    volumes = [
      "/var/lib/${userGroupName}:/config"
      "/mnt/media/downloads/dst/Books:/downloads"
      "/mnt/media/Books:/library"
    ];
    environment = {
      # PUID = "1000";
      # PGID = "1000";
      PUID = builtins.toString userGroupId;
      PGID = builtins.toString userGroupId;
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

