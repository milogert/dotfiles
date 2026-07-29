{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    listenAddresses = [ "*:631" ];
    browsing = true;
    allowFrom = [ "all" ];
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      foomatic-filters
      brlaser
      cups-brother-hll2340dw
    ];
    defaultShared = true;
  };

  networking.firewall.allowedTCPPorts = [ 631 ];
  networking.firewall.allowedUDPPorts = [ 631 ];

  services.traefik.dynamicConfigOptions.http = {
    routers.printer = {
      entryPoints = [ "websecure" ];
      rule = "Host(`printer.milogert.dev`)";
      service = "printer";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "printer.milogert.dev"; } ];
      };
    };

    services.printer.loadBalancer.servers = [ { url = "http://localhost:631"; } ];
  };
}
