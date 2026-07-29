{ pkgs, ... }:

let
  hassId = 986;
in {
  users.users.hass = {
    home = "/var/lib/hass";
    createHome = true;
    group = "hass";
    uid = hassId;
    isSystemUser = true;
  };

  users.groups.hass = {
    members = [ "hass" ];
    gid = hassId - 2;
  };

  virtualisation.oci-containers.containers = {
    home-assistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      ports = ["8123:8123"];
      volumes = [
        "/var/lib/hass:/config"
      ];
      environment = {
        PUID = "986";
        PGID = "984";
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.hass = {
      entryPoints = [ "websecure" ];
      rule = "Host(`home.milogert.dev`)";
      service = "hass";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "home.milogert.dev"; } ];
      };
    };

    services.hass.loadBalancer.servers = [ { url = "http://localhost:8123"; } ];
  };
}
