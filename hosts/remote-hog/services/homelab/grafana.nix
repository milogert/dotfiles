{ pkgs, ... }:

{
  services.grafana = {
    enable = true;

    addr = "0.0.0.0";
    domain = "grafana.milogert.dev";

    provision = {
      enable = true;

      datasources = [
        {
          name = "Prometheus";
          url = "https://prometheus.milogert.dev";
          type = "prometheus";
        }
        {
          name = "Loki";
          url = "http://localhost:3100";
          type = "loki";
        }
      ];

      # dashboards = [
      #   {
      #     name = "Memory Free";
      #     options.path = ./grafana;
      #   }
      # ];

      # notifiers = [
      #   {
      #     name = "Memory Running Out";
      #   }
      # ];
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.grafana = {
      entryPoints = [ "websecure" ];
      rule = "Host(`grafana.milogert.dev`)";
      service = "grafana";

      tls = {
        certResolver = "letsEncrypt";
        domains = [ { main = "grafana.milogert.dev"; } ];
      };
    };

    services.grafana.loadBalancer.servers = [ { url = "http://localhost:3000"; } ];
  };
}
