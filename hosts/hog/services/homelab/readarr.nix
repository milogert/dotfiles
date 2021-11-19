{ pkgs, ... }:

let
  readarrId = 990;
in {
  users.users.readarr = {
    home = "/var/lib/readarr";
    createHome = true;
    group = "readarr";
    uid = readarrId;
    isSystemUser = true;
  };

  users.groups.readarr = {
    members = [ "readarr" ];
    gid = readarrId;
  };

  virtualisation.oci-containers.containers = {
    readarr = {
      image = "ghcr.io/hotio/readarr:release";
      ports = ["8787:8787"];
      volumes = [
        "/var/lib/readarr:/config"
      ];
      environment = {
        PUID = "990";
        PGID = "990";
      };
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

    services.readarr.loadBalancer.servers = [ { url = "http://localhost:8787"; } ];
  };
}
