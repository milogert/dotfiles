{ pkgs, ... }:

let
  service = "infinity-card-generator";
  port = "4010";
  repo = "/home/milo/.openclaw/workspace/projects/infinity-card-generator";
  domain = "infinity-card-generator.apps.ai.milogert.com";
in {
  systemd.services.${service} = {
    description = "Infinity card generator Phoenix app";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "milo";
      Group = "users";
      WorkingDirectory = repo;
      EnvironmentFile = "/home/milo/.config/infinity-card-generator.env";
      Environment = [ "HOME=/home/milo" ];
      ExecStart = "${pkgs.bash}/bin/bash -lc 'exec ${pkgs.nix}/bin/nix develop --command mix phx.server'";
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
