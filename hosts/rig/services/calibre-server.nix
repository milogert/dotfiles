{ pkgs, ... }:

{
  services.calibre-server = {
    enable = true;

    libraries = [
      "/var/lib/calibre-server/main"
    ];

  };
}
