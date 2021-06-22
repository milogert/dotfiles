{ pkgs, ... }:

rec {
  security.acme = {
    email = "milo@milogert.com";
    acceptTerms = true;
  };

  services = {
    # This is not needed, but I'll be explicit.
    nginx = {
      enable = true;

      virtualHosts = {
        "_" = {
          default = true;
          root = "/var/www/html";

          listen = [
            { addr = "0.0.0.0"; port = 80; }
            #{ addr = "0.0.0.0"; port = 443; }
          ];
        };

        # Most of this is generated from `tt-rss` below, this just needs some
        # tweaking
        "rss.milogert.com" = {
          addSSL = true;
          enableACME = true;
        };

        "bggrss.milogert.com" = {
          addSSL = true;
          enableACME = true;

          listen = [
            { addr = "0.0.0.0"; port = 443; }
          ];

          locations."/" = {
            proxyPass = "http://localhost:5000";
          };
        };
      };
    };

    cfdyndns = {
      enable = true;
      apikeyFile = "/etc/cloudflare.apikey";
      email = "milo@milogert.com";
      records = [
        "bggrss.milogert.com"
        "books.milogert.com"
        "rss.milogert.com"
        "ssh.milogert.com"
        "usenet.milogert.com"
      ];
    };

    tt-rss = {
      enable = true;
      selfUrlPath = "https://rss.milogert.com";
      auth.autoLogin = false;
      virtualHost = "rss.milogert.com";
    };

    longview = {
      enable = false;
      apiKey = "";

      apacheStatusUrl = "";
      nginxStatusUrl = "";

      mysqlUser = "";
      mysqlPassword = "";
    };
  };
}
