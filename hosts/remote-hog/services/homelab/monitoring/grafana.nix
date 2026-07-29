{ pkgs, ... }:

let
  node-exporter-dashboard-json = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/rfrail3/grafana-dashboards/master/prometheus/node-exporter-full.json";
    sha256 = "sha256-S0xTDU5xHRuOSPOgGQb9EMY7MiqJ6L1JrQsN8LrnXV8=";
  };
in {
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

      dashboards = [
        {
          name = "node-exporter";
          type = "file";
          folder = "Server";
          options.path = "/etc/grafana-dashboards/node-exporter.json";
        }
      ];
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

  environment.etc = {
    grafana-node-exporter = {
      source = node-exporter-dashboard-json;
      target = "/grafana-dashboards/node-exporter.json";
    };
  };
}
