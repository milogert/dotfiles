{ config, pkgs, ... }:

let
  extraPlugins = pkgs.callPackage ./custom-plugins.nix {};
in {
  services.tt-rss = {
    enable = true;
    selfUrlPath = "https://rss.milogert.com";
    auth.autoLogin = false;
    virtualHost = "rss.milogert.com";
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
      # Need to override the listener because of Traefik
      listen = [
        {
          addr = "localhost";
          port = 8320;
        }
      ];

      # Optimal php config?
      locations."~ \\.php$".extraConfig = ''
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
      '';
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
