{ config, pkgs, ... }:

{
  services.prometheus = {
    enable = true;

    alertmanager = {
      enable = true;

      webExternalUrl = "https://alertmanager.milogert.dev";

      configuration = {
        route = {
          receiver = "default-receiver";
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "4h";
          group_by = ["cluster" "alertname"];
          # All alerts that do not match the following child routes
          # will remain at the root node and be dispatched to 'default-receiver'.
          # routes = [
          #   {
          #     # All alerts with service=mysql or service=cassandra
          #     # are dispatched to the database pager.
          #     receiver = "database-pager";
          #     group_wait = "10s";
          #     matchers = {
          #       service = "mysql|cassandra";
          #     };
          #   }
          #   {
          #     # All alerts with the team=frontend label match this sub-route.
          #     # They are grouped by product and environment rather than cluster
          #     # and alertname.
          #     receiver = "frontend-pager";
          #     group_by = ["product" "environment"];
          #     matchers = {
          #       team="frontend";
          #     };
          #   }
          # ];
        };

        receivers = [
          {
            name = "default-receiver";
            # email_configs = [
            #   {
            #     to = "milo+alerts@milogert.com";
            #   }
            # ];
          }
        ];
      };
    };

    alertmanagers = [
      {
        scheme = "https";
        path_prefix = "/";
        static_configs = [ {
          targets = [ "alertmanager.milogert.dev" ];
        } ];
      }
    ];

    rules = [
      ''
        groups:
          - name: test_group
            rules:
            - record: node_memory_MemFree_bytes
              expr: node_memory_MemFree_bytes
            - alert: less than 1.5GiB memory for an hour
              expr: node_memory_MemFree_bytes < 1.5e+9
              for: 3600s
              # annotations:
                # title: Low memory on {{ $labels.hostname }}
                # description: {{ $labelshostname }} has had sustained memory usage for over an hour.
      ''
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };

      systemd.enable = true;
    };

    scrapeConfigs = [
      {
        job_name = "theseus";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      prometheus = {
        entryPoints = [ "websecure" ];
        rule = "Host(`prometheus.milogert.dev`)";
        service = "prometheus";

        tls = {
          certResolver = "letsEncrypt";
          domains = [ { main = "prometheus.milogert.dev"; } ];
        };
      };

      alertmanager = {
        entryPoints = [ "websecure" ];
        rule = "Host(`alertmanager.milogert.dev`)";
        service = "alertmanager";

        tls = {
          certResolver = "letsEncrypt";
          domains = [ { main = "alertmanager.milogert.dev"; } ];
        };
      };
    };

    services = {
      prometheus.loadBalancer.servers = [ { url = "http://localhost:9090"; } ];
      alertmanager.loadBalancer.servers = [ { url = "http://localhost:9093"; } ];
    };
  };
}
