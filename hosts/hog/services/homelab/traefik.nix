{
  config,
  lib,
  pkgs,
  ...
}:

let
  format = pkgs.formats.toml { };
  dynamicDir = "/srv/traefik-dynamic";

  dynamicConfigFile = format.generate "traefik-dynamic-static.toml" config.services.traefik.dynamicConfigOptions;

  staticConfigFile = format.generate "traefik-static.toml" {
    accessLog.filePath = "/var/lib/traefik/traefik.access.log";

    certificatesResolvers.letsEncrypt.acme = {
      email = "milo@milogert.com";
      storage = "/var/lib/traefik/acme-prod.json";
      dnsChallenge.provider = "route53";
    };

    entryPoints = {
      web = {
        address = ":80";
        http.redirections.entryPoint = {
          to = "websecure";
          scheme = "https";
        };
      };

      websecure.address = ":443";
    };

    api.dashboard = true;

    providers.file = {
      directory = dynamicDir;
      watch = true;
    };
  };
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.traefik = {
    enable = true;
    staticConfigFile = staticConfigFile;
    environmentFiles = [ "/etc/secrets/route53.env" ];
    group = "users";
  };

  systemd.tmpfiles.rules = [
    "d ${dynamicDir} 2775 traefik users -"
  ];

  system.activationScripts.traefikDynamicConfig = lib.stringAfter [ "users" "groups" ] ''
    install -d -m 2775 -o traefik -g users ${dynamicDir}
    install -m 0644 ${dynamicConfigFile} ${dynamicDir}/00-nixos-static.toml
  '';

  services.traefik.dynamicConfigOptions.http = {
    routers.traefik = {
      entryPoints = [ "websecure" ];
      rule = "Host(`traefik.milogert.dev`)";
      service = "api@internal";

      tls = {
        certResolver = "letsEncrypt";
        domains = [
          {
            main = "milogert.dev";
            sans = [ "*.milogert.dev" ];
          }
        ];
      };
    };

    routers.ai = {
      entryPoints = [ "websecure" ];
      rule = "Host(`ai.milogert.com`)";
      service = "ai";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "ai.milogert.com"; } ];
      };
    };

    services.ai.loadBalancer.servers = [ { url = "http://localhost:18789"; } ];

    routers.apps-ai-wildcard = {
      entryPoints = [ "websecure" ];
      rule = "Host(`apps.ai.milogert.com`)";
      service = "noop@internal";

      tls = {
        certResolver = "letsEncrypt";
        domains = [
          {
            main = "apps.ai.milogert.com";
            sans = [ "*.apps.ai.milogert.com" ];
          }
        ];
      };
    };
  };
}
