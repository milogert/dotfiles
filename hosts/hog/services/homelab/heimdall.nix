{ pkgs, ... }:

let
  hiemdallId = 991;
in {
  users.users.heimdall = {
    home = "/var/lib/heimdall";
    createHome = true;
    group = "heimdall";
    uid = hiemdallId;
    isSystemUser = true;
  };

  users.groups.heimdall = {
    members = [ "heimdall" ];
    gid = hiemdallId;
  };

  virtualisation.oci-containers.containers = {
    heimdall = {
      image = "linuxserver/heimdall:latest";
      ports = ["81:80"];
      volumes = [
        "/var/lib/heimdall:/config"
      ];
      environment = {
        PUID = "991";
        PGID = "991";
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.heimdall = {
      entryPoints = [ "websecure" ];
      rule = "Host(`milogert.dev`)";
      service = "heimdall";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "milogert.dev"; } ];
      };
    };

    services.heimdall.loadBalancer.servers = [ { url = "http://localhost:81"; } ];
  };
}
