{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    package = pkgs.jellyfin // {
      ffmpeg = pkgs.ffmpegFull;
    };
  };

  users.users.jellyfin.extraGroups = [ "render" ];

  environment.systemPackages = with pkgs; [
    libva-utils
    radeontop
  ];

  services.traefik.dynamicConfigOptions.http = {
    routers.jellyfin = {
      entryPoints = [ "websecure" ];
      rule = "Host(`jellyfin.milogert.com`)";
      service = "jellyfin";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "jellyfin.milogert.com"; } ];
      };
    };

    services.jellyfin.loadBalancer.servers = [ { url = "http://localhost:8096"; } ];
  };
}
