{ pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."localhost" = {
      # Change the port from port 80, since traefik is listening on that one.
      # Nginx is here just for applications that need it like tt-rss.
      listen = [
        {
          addr = "localhost";
          port = 8080;
        }
      ];
    };
  };
}
