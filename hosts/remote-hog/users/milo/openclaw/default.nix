{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.openclaw = {
    enable = true;

    documents = ./documents;

    instances.default = {
      enable = true;
      package = pkgs.openclaw;
      # configPath = "${config.home.homeDirectory}/.config/openclaw/openclaw.json";
      # stateDir = "${config.xdg.dataHome}/openclaw";
      # workspaceDir = "${config.xdg.dataHome}/openclaw/workspace";
      stateDir = "${config.home.homeDirectory}/.openclaw";
      workspaceDir = "${config.home.homeDirectory}/.openclaw/workspace";
      gatewayPort = 18789;

      config = {
        gateway = {
          mode = "local";
          auth = {
            mode = "token";
            # Change me
            token = "some funky token";
          };

          trustedProxies = [
            "127.0.0.1"
            "::1"
            "localhost"
          ];
          # Optional. Default false.
          # Only enable if your proxy cannot provide X-Forwarded-For.
          allowRealIpFallback = false;

          controlUi = {
            allowedOrigins = [
              "https://ai.milogert.com"
            ];
          };
        };

        auth = {
          profiles = {
            "anthropic:default" = {
              provider = "anthropic";
              mode = "api_key";
            };
            "openai:default" = {
              provider = "openai";
              mode = "token";
            };
          };
        };

        agents = {
          defaults = {
            model = {
              primary = "anthropic/claude-sonnet-4-5";
              fallbacks = [
                "anthropic/claude-opus-4-5"
                "openai/gpt-4o"
              ];
            };
            models = {
              "anthropic/claude-sonnet-4-5" = { };
            };
            workspace = "~/.openclaw/workspace";
            maxConcurrent = 4;
          };
          list = [
            {
              id = "main";
              default = true;
            }
          ];
        };

        # bindings = [
        #   {
        #     agentId = "main";
        #     match = {
        #       channel = "discord";
        #     };
        #   }
        # ];

        # commands = {
        #   native = "auto";
        #   nativeSkills = "auto";
        # };

        # hooks = {
        #   internal = {
        #     enabled = true;
        #     entries = {
        #       session-memory = {
        #         enabled = true;
        #       };
        #       boot-md = {
        #         enabled = true;
        #       };
        #     };
        #   };
        # };

        logging = {
          level = "info";
          # file = "/tmp/openclaw/openclaw-YYYY-MM-DD.log";
          consoleLevel = "debug";
          # consoleStyle = "pretty";
          # redactSensitive = "tools";
          # redactPatterns = [ "sk-.*" ];
        };

        channels = {
          telegram = {
            enabled = true;
            dmPolicy = "pairing";
            groups = {
              "*" = {
                requireMention = true;
              };
            };
            groupPolicy = "allowlist";
            streamMode = "partial";
          };

          discord = {
            enabled = true;
            token = {
              # source = "file";
              # provider = "files";
              # id = "discord";
              source = "env";
              provider = "default";
              id = "DISCORD_BOT_TOKEN";
            };
            groupPolicy = "allowlist";
            guilds = {
              "1472133243368116264" = {
                requireMention = false;
                channels = {
                  "1472133243997524012" = {
                    allow = true;
                  };
                };
              };
            };
          };
        };

        tools = {
          web = {
            search = {
              provider = "brave";
              maxResults = 5;
              timeoutSeconds = 30;
            };
          };
        };

        skills = {
          entries = {
            agentmail = {
              enabled = true;
            };
          };
        };

        # plugins = {
        #   entries = {
        #     discord = {
        #       enabled = true;
        #     };
        #
        #     telegram = {
        #       enabled = true;
        #     };
        #   };
        # };
      };
    };
  };

  systemd.user.services.openclaw-gateway = {
    Service.EnvironmentFile = "${config.home.homeDirectory}/.openclaw-secrets/env";
  };
}
