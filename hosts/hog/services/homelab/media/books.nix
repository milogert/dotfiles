{ config, pkgs, ... }:

let
  hostPort = "8788";
  containerPort = hostPort;
  image = "crocodilestick/calibre-web-automated:latest";
in
{
  virtualisation.oci-containers.containers.calibre-web-automated = {
    image = image;
    ports = [ "${hostPort}:${containerPort}" ];
    volumes = [
      # CW users migrating should stop their existing CW instance, make a copy
      # of the config folder, and bind that here to carry over all of their
      # user settings ect.
      "${config.users.users.media.home}/config/calibre-web-automated/config:/config"
      # This is an ingest dir, NOT a library one. Anything added here will be
      # automatically added to your library according to the settings you have
      # configured in CWA Settings page. All files placed here are REMOVED AFTER
      # PROCESSING
      "${config.users.users.media.home}/config/calibre-web-automated/ingest:/cwa-book-ingest"
      # If you don't have an existing library, CWA will automatically create
      # one at the bind provided here
      "${config.users.users.media.home}/config/calibre-web-automated/library:/calibre-library"
      # If you use calibre plugins, you can bind your plugins folder here to
      # have CWA attempt to add them to its workflow (WIP)
      # If you are starting with a fresh install, you also need to copy
      # customize.py.json to the Calibre config volume above, in
      # /path/to/config/folder/.config/calibre/customize.py.json, see the note
      # below for more info
      "${config.users.users.media.home}/config/calibre-web-automated/plugins:/config/.config/calibre/plugins"

    ];
    environment = {
      PUID = builtins.toString config.users.users.media.uid;
      PGID = builtins.toString config.users.groups.media.gid;
      CWA_PORT_OVERRIDE = containerPort;
      HARDCOVER_TOKEN = "your_hardcover_api_key_here";
      TZ = "America/Detroit";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.books = {
      entryPoints = [ "websecure" ];
      rule = "Host(`books.milogert.com`)";
      service = "books";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "books.milogert.com"; } ];
      };
    };

    services.books.loadBalancer.servers = [ { url = "http://localhost:${hostPort}"; } ];
  };
}
