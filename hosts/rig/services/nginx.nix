{ pkgs, ... }:

rec {
  security.acme = {
    email = "milo@milogert.com";
    acceptTerms = true;
  };

  services.nginx = {
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
        root = "/var/lib/tt-rss";

        addSSL = true;
        enableACME = true;

        locations."/" = {
          index = "index.php";
        };

        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_buffers 16 16k;
            fastcgi_buffer_size 32k;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/run/phpfpm/tt-rss.sock;
            fastcgi_index index.php;
          '';
        };
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

      "books.milogert.com" = {
        addSSL = true;
        enableACME = true;

        listen = [
          { addr = "0.0.0.0"; port = 443; }
        ];

        locations."/" = {
          proxyPass = "http://localhost:8080";
        };
      };
    };
  };
}
