{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.traefik.enable = true;

  services.traefik.staticConfigOptions = {
    log = {
      filePath = "/var/lib/traefik/traefik.system.log";
      level = "DEBUG";
    };

    accessLog.filePath = "/var/lib/traefik/traefik.access.log";

    certificatesResolvers.letsEncrypt.acme = {
      email = "milo@milogert.com";
      storage = "/var/lib/traefik/acme-prod.json";

      dnsChallenge.provider = "linode";

      # Remove for production.
      # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };

    # http = {
    #   middlewares = {
    #     errorPage = {
    #       errors = {
    #         status = "400-599";
    #         service = "heimdall";
    #       };
    #     };
    #   };
    # };

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

    # pilot.token = builtins.readFile ("/etc/secrets/traefik-pilot.token");
  };

  # This gives access to the dashboard.
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
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile =
    "/etc/secrets/linode-milogert.com.env";
}
