{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      # log = {
      # filePath = "/var/lib/traefik/traefik.system.log";
      # level = "DEBUG";
      # };

      accessLog.filePath = "/var/lib/traefik/traefik.access.log";

      certificatesResolvers.letsEncrypt.acme = {
        email = "milo@milogert.com";
        storage = "/var/lib/traefik/acme-prod.json";

        dnsChallenge = {
          provider = "route53";
          resolvers = [
            "2606:4700:4700::1111:53"
            "2606:4700:4700::1001:53"
          ];
        };

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

    # This gives access to the dashboard.
    dynamicConfigOptions.http = {
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

      routers.wishlist = {
        entryPoints = [ "websecure" ];
        rule = "Host(`rrw.milogert.com`) || Host(`wishlist.milogert.com`)";
        service = "noop@internal";

        middlewares = [ "wishlistRedirect" ];
        tls = {
          certResolver = "letsEncrypt";
          domains = [
            {
              main = "rrw.milogert.com";
              sans = [ "wishlist.milogert.com" ];
            }
          ];
        };
      };

      middlewares = {
        wishlistRedirect = {
          redirectRegex = {
            regex = "^https://(rrw|wishlist)\\.milogert\\.com";
            replacement = "https://www.icloud.com/pages/07eSQUDeSG3CPPBAih4dGMDRw#Rolling-Release_Wishlist";
          };
        };
      };
    };
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = "/etc/secrets/route53.env";
}
