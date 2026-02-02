{ pkgs, ... }:

let
  userGroupName = "livebook";
  userGroupId = 990;
  containerPort1 = "8080";
  containerPort2 = "8081";
  hostPort1 = "8082";
  hostPort2 = "8083";
  image = "livebook/livebook:latest";
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
    ports = [
      "${hostPort1}:${containerPort1}"
      "${hostPort2}:${containerPort2}"
    ];
    volumes = [
      "/var/lib/${userGroupName}:/config"
    ];
    environment = {
      PUID = builtins.toString userGroupId;
      PGID = builtins.toString userGroupId;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.livebook = {
      entryPoints = [ "websecure" ];
      rule = "Host(`livebook.milogert.com`)";
      service = "livebook";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "livebook.milogert.com"; } ];
      };
    };

    services.livebook.loadBalancer.servers = [ { url = "http://localhost:${hostPort1}"; } ];
  };
}
