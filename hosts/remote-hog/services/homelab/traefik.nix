{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.traefik.enable = true;

  services.traefik.staticConfigOptions = {
    /* log = { */
    /*   filePath = "/var/lib/traefik/traefik.system.log"; */
    /*   level = "DEBUG"; */
    /* }; */

    accessLog.filePath = "/var/lib/traefik/traefik.access.log";

    certificatesResolvers.letsEncrypt.acme = {
      email = "milo@milogert.com";
      storage = "/var/lib/traefik/acme-prod.json";

      dnsChallenge.provider = "route53";

      # Remove for production.
      # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
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


    # pilot.token = builtins.readFile ("/etc/secrets/traefik-pilot.token");
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile =
    "/etc/secrets/route53.env";

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

    # This router exists only to provision the wildcard certificate for
    # dynamically-created app subdomains under *.apps.ai.milogert.com.
    routers.apps-ai-wildcard = {
      entryPoints = [ "websecure" ];
      rule = "Host(`apps.ai.milogert.com`)";
      service = "noop@internal";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ {
          main = "apps.ai.milogert.com";
          sans = [ "*.apps.ai.milogert.com" ];
        } ];
      };
    };

  };
}
