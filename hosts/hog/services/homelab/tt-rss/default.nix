{ config, pkgs, ... }:

let
  extraPlugins = pkgs.callPackage ./custom-plugins.nix {};
in {
  services.tt-rss = {
    enable = true;
    selfUrlPath = "https://rss.milogert.com";
    auth.autoLogin = false;
    # Virtual host is not generated here at all. It's generated below. I might
    # not need to do this still, but I am sticking with it.
    virtualHost = null;
    plugins = [
      "auth_internal"
    ];
    pluginPackages = [
      extraPlugins.tt-rss-plugin-feediron
      # pkgs.tt-rss-plugin-feediron
    ];
  };

  services.nginx.virtualHosts = {
    "rss.milogert.com" = {
      listen = [
        {
          addr = "localhost";
          port = 8320;
        }
      ];

      root = "${config.services.tt-rss.root}/www";

      locations."/" = {
        index = "index.php";
      };

      locations."^~ /feed-icons" = {
        root = "${config.services.tt-rss.root}";
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
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.rss = {
      entryPoints = [ "websecure" ];
      rule = "Host(`rss.milogert.com`)";
      service = "rss";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "rss.milogert.com"; } ];
      };
    };

    services.rss.loadBalancer.servers = [ { url = "http://localhost:8320"; } ];
  };
}
