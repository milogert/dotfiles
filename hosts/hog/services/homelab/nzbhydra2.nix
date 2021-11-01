{ pkgs, ... }:

{
  services.nzbhydra2 = {
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.hydra = {
      entryPoints = [ "websecure" ];
      rule = "Host(`hydra.milogert.dev`)";
      service = "hydra";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "hydra.milogert.dev"; } ];
      };
    };

    services.hydra.loadBalancer.servers = [ { url = "http://localhost:5076"; } ];
  };
}
