{ pkgs, ... }:

let
  service = "group-expenses";
  port = "4011";
  repo = "/home/milo/.openclaw/workspace/projects/group-expenses";
  domain = "group-expenses.apps.ai.milogert.com";
in {
  systemd.services.${service} = {
    description = "Group Expenses Phoenix app";
    after = [ "network-online.target" "postgresql.service" ];
    wants = [ "network-online.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "milo";
      Group = "users";
      WorkingDirectory = repo;
      EnvironmentFile = "/home/milo/.config/group-expenses.env";
      Environment = [ "HOME=/home/milo" ];
      ExecStart = "${pkgs.bash}/bin/bash -lc 'exec ${pkgs.nix}/bin/nix develop --command ${pkgs.bash}/bin/bash -lc \"mix ecto.migrate && exec mix phx.server\"'";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 20;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.${service} = {
      inherit service;
      entryPoints = [ "websecure" ];
      rule = "Host(`${domain}`)";
      tls = { };
    };

    services.${service}.loadBalancer.servers = [ {
      url = "http://127.0.0.1:${port}";
    } ];
  };
}
