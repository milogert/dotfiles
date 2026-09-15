{ config, pkgs, ... }:

let
  service = "kosync";
  hostPort = "17200";
  configPrefix = "${config.users.users.media.home}/config/${service}";
  kosync = pkgs.callPackage ../../../packages/kosync { };
in {
  systemd.tmpfiles.rules = [
    "d ${configPrefix} 0750 media media - -"
    "d ${configPrefix}/app 0750 media media - -"
    "d ${configPrefix}/data/redis 0750 media media - -"
    "d ${configPrefix}/logs/app 0750 media media - -"
    "d ${configPrefix}/ssl 0750 media media - -"
    "d ${configPrefix}/tmp 0750 media media - -"
  ];

  # KOReader sync server uses Redis DB 1 in production (DB 0 will look empty).
  # Useful checks:
  #   curl -H 'Accept: application/vnd.koreader.v1+json' https://${service}.milogert.com/healthcheck
  #   redis-cli -h 127.0.0.1 -p 6379 -n 1 keys '*'
  services.redis.servers.${service} = {
    enable = true;
    user = "media";
    group = "media";
    bind = "127.0.0.1";
    port = 6379;
    openFirewall = false;
    settings.dir = pkgs.lib.mkForce "${configPrefix}/data/redis";
  };

  systemd.services."redis-${service}".serviceConfig = {
    ProtectHome = pkgs.lib.mkForce false;
    ReadWritePaths = [ "${configPrefix}/data/redis" ];
  };

  systemd.services.${service} = {
    description = "KOReader sync server";
    after = [ "network.target" "redis-${service}.service" ];
    requires = [ "redis-${service}.service" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      ENABLE_USER_REGISTRATION = "true";
      GIN_ENV = "production";
    };

    preStart = ''
      ${pkgs.rsync}/bin/rsync -a --delete ${kosync}/share/kosync/ ${configPrefix}/app/
      chmod -R u+w ${configPrefix}/app
      rm -rf ${configPrefix}/app/logs ${configPrefix}/app/tmp
      ln -s ${configPrefix}/logs/app ${configPrefix}/app/logs
      ln -s ${configPrefix}/tmp ${configPrefix}/app/tmp

      if [ ! -e ${configPrefix}/ssl/nginx.key ] || [ ! -e ${configPrefix}/ssl/nginx.crt ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
          -keyout ${configPrefix}/ssl/nginx.key \
          -out ${configPrefix}/ssl/nginx.crt \
          -subj "/"
      fi

      ${pkgs.gnused}/bin/sed -i \
        -e 's|/etc/nginx/ssl/nginx.key|${configPrefix}/ssl/nginx.key|g' \
        -e 's|/etc/nginx/ssl/nginx.crt|${configPrefix}/ssl/nginx.crt|g' \
        ${configPrefix}/app/config/nginx.conf

      grep -q '^error_log logs/nginx-error.log;' ${configPrefix}/app/config/nginx.conf \
        || ${pkgs.gnused}/bin/sed -i '1i error_log logs/nginx-error.log;' ${configPrefix}/app/config/nginx.conf

      grep -q '^daemon off;' ${configPrefix}/app/config/nginx.conf \
        || echo 'daemon off;' >> ${configPrefix}/app/config/nginx.conf
    '';

    serviceConfig = {
      User = "media";
      Group = "media";
      WorkingDirectory = "${configPrefix}/app";
      ExecStart = "${kosync}/bin/kosync";
      Restart = "on-failure";
      RestartSec = "5s";
    };
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
