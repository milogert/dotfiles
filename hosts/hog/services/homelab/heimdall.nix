{ pkgs, ... }:

let
  userGroupName = "heimdall";
  userGroupId = 991;
  hostPort = "81";
  containerPort = "80";
  image = "linuxserver/heimdall:latest";
in
{
  users.users."${userGroupName}" = {
    home = "/var/lib/${userGroupName}";
    createHome = true;
    group = userGroupName;
    uid = userGroupId;
    isSystemUser = true;
  };

  users.groups."${userGroupName}" = {
    members = [ userGroupName ];
    gid = userGroupId;
  };

  virtualisation.oci-containers.containers."${userGroupName}" = {
    image = image;
    ports = [ "${hostPort}:${containerPort}" ];
    volumes = [
      "/var/lib/${userGroupName}:/config"
    ];
    environment = {
      PUID = builtins.toString userGroupId;
      PGID = builtins.toString userGroupId;
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

    services.heimdall.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}
