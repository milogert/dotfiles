{ config, pkgs, ... }:

let
  hermesHome = "/var/lib/hermes/.hermes";

  profiles = [
    "color_theorist"
    "infinity_lore"
    "lore_master"
    "oil_technician"
    "paint_coach"
    "staff_engineer"
    "trader"
  ];

  files = [
    "SOUL.md"
    "config.yaml"
    "cron/"
    "plugins/"
    "profile.yaml"
    "scripts/"
    "skills/"
  ];

  mapProfileFiles =
    profile:
    [
      "d ${hermesHome}/profiles/${profile} 0750 hermes hermes - -"
    ]
    ++ (builtins.map (
      file: "L+ ${hermesHome}/profiles/${profile}/${file} - - - - ${./profiles/${profile}/${file}}"
    ) files);

  rules = pkgs.lib.flatten (builtins.map mapProfileFiles profiles);
in
{
  age.secrets.hermes-discord-bot-token = {
    file = ../../../../secrets/hermes-agent/DISCORD_BOT_TOKEN.age;
    owner = "hermes";
    group = "hermes";
    mode = "0400";
  };

  age.secrets.hermes-api-server-key = {
    file = ../../../../secrets/hermes-agent/API_SERVER_KEY.age;
    owner = "hermes";
    group = "hermes";
    mode = "0400";
  };

  age.secrets.hermes-dashboard-oauth-client-id = {
    file = ../../../../secrets/hermes-agent/HERMES_DASHBOARD_OAUTH_CLIENT_ID.age;
    owner = "hermes";
    group = "hermes";
    mode = "0400";
  };

  services.hermes-agent = {
    enable = true;

    environment = {
      DISCORD_ALLOWED_USERS = "165074227752337408";
      DISCORD_HOME_CHANNEL = "1472133243997524012";
      GATEWAY_ALLOW_ALL_USERS = "true";
      API_SERVER_ENABLED = "true";
      API_SERVER_PORT = "8642";
    };

    environmentFiles = [
      config.age.secrets.hermes-discord-bot-token.path
      config.age.secrets.hermes-api-server-key.path
    ];

    # # Makes `hermes` available on the host and points it at the same
    # # state used by the systemd service.
    # addToSystemPackages = true;

    # Discord support isn't included in the minimal Nix closure.
    extraDependencyGroups = [
      "messaging"
    ];

    # environmentFiles = [
    #   config.sops.secrets.hermes-env.path
    # ];

    settings = {
      web.backend = "nous";

      timezone = "America/Detroit";

      model = {
        default = "deepseek/deepseek-v4-pro";
      };

      display = {
        skin = "ares";
      };

      # The important bit for Discord.
      streaming = {
        enabled = true;
        transport = "edit";

        # Hermes' documented defaults are approximately these values.
        # 300 ms should feel reasonably fluid without going nuts on
        # Discord message edits.
        edit_interval = 0.3;
        buffer_threshold = 40;

        cursor = " ▉";
      };

      discord = {
        # In normal server channels, Trace only speaks when mentioned.
        require_mention = true;

        # Once Trace creates a thread, talking normally is nicer than
        # having to @mention every message.
        thread_require_mention = false;

        # I like this behavior for an agent: mention it in #general,
        # and that interaction gets isolated into a thread.
        auto_thread = true;

        # Gives you visible acknowledgement while tools/model are working.
        reactions = true;

        # Hermes can pull recent Discord context into a new interaction.
        history_backfill = true;
        history_backfill_limit = 50;

        # If you eventually create a dedicated #trace channel, put its
        # channel ID here so you don't need to @Trace every time.
        free_response_channels = [
          # "123456789012345678"
        ];

        ignored_channels = [
          # "123456789012345678"
        ];
        
      };

      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };

      terminal = {
        backend = "local";
        timeout = 180;
      };

      toolsets = [
        "all"
      ];

      dashboard = {
        theme = "nous-blue";
        public_url = "https://ai.milogert.com";
      };
    };
  };

  systemd.tmpfiles.rules = rules;

  systemd.services.hermes-dashboard = {
    description = "Hermes Dashboard";
    after = [
      "network-online.target"
      "hermes-agent.service"
    ];
    wants = [ "network-online.target" ];

    environment = {
      HOME = "/var/lib/hermes";
      HERMES_HOME = "/var/lib/hermes/.hermes";
    };

    serviceConfig.EnvironmentFile = config.age.secrets.hermes-dashboard-oauth-client-id.path;

    serviceConfig = {
      User = "hermes";
      Group = "hermes";
      WorkingDirectory = "/var/lib/hermes/workspace";
      # This seems to not work because of the reverse proxy.
      # ExecStart = "${pkgs.hermes-agent}/bin/hermes dashboard --host 127.0.0.1 --port 9119 --no-open";
      ExecStart = "${pkgs.hermes-agent}/bin/hermes dashboard --host 0.0.0.0 --port 9119 --no-open";
      Restart = "always";
      RestartSec = 5;
    };

    wantedBy = [ "multi-user.target" ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      ai = {
        entryPoints = [ "websecure" ];
        rule = "Host(`ai.milogert.com`)";
        service = "ai";

        tls = {
          certResolver = "letsEncrypt";
          domains = [ { main = "ai.milogert.com"; } ];
        };
      };

      apps-ai-wildcard = {
        entryPoints = [ "websecure" ];
        rule = "Host(`apps.ai.milogert.com`)";
        service = "noop@internal";

        tls = {
          certResolver = "letsEncrypt";
          domains = [
            {
              main = "apps.ai.milogert.com";
              sans = [ "*.apps.ai.milogert.com" ];
            }
          ];
        };
      };
    };

    services.ai.loadBalancer.servers = [ { url = "http://localhost:9119"; } ];
  };
}
