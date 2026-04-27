{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.openclaw = {
    enable = true;

    package = pkgs.openclaw;

    instances.default = {
      enable = true;
      package = pkgs.openclaw;
      stateDir = "${config.home.homeDirectory}/.openclaw";
      workspaceDir = "${config.home.homeDirectory}/.openclaw/workspace";
      gatewayPort = 18789;

      config =
        let
          discordUserId = "165074227752337408";
        in
        {
          gateway = {
            mode = "local";
            auth = {
              mode = "token";
              token = "\${OPENCLAW_GATEWAY_TOKEN}";
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
              "openai-codex:default" = {
                provider = "openai-codex";
                mode = "oauth";
              };
            };
          };

          agents = {
            defaults = {
              model = {
                primary = "openai-codex/gpt-5.4";
                fallbacks = [ ];
              };
              workspace = "~/.openclaw/workspace";
              maxConcurrent = 4;
              blockStreamingDefault = "off";
            };
            list = [
              {
                id = "main";
                default = true;
              }
            ];
          };

          hooks = {
            enabled = true;
            token = "\${OPENCLAW_HOOKS_TOKEN}";
            path = "/hooks";

            mappings = [
              {
                id = "mail";
                match.path = "mail";
                action = "agent";
                agentId = "main";
                wakeMode = "now";
                name = "Generic Hook";
                deliver = true;
                channel = "last";
                transform = {
                  module = "./generic-message.js";
                };
              }
            ];
          };

          logging = {
            level = "info";
            # file = "/tmp/openclaw/openclaw-YYYY-MM-DD.log";
            consoleLevel = "debug";
            # consoleStyle = "pretty";
            # redactSensitive = "tools";
            # redactPatterns = [ "sk-.*" ];
          };

          channels = {
            discord =
              let
                guildId = "1472133243368116264";
              in
              {
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
                  "${guildId}" = {
                    requireMention = false;
                  };
                };
                maxLinesPerMessage = 30;
                allowFrom = [
                  discordUserId
                ];
                streaming = {
                  mode = "partial";
                  chunkMode = "newline";
                  preview.chunk = {
                    minChars = 300;
                    maxChars = 1200;
                    breakPreference = "paragraph";
                  };
                };
                voice = {
                  enabled = true;
                  # allowFrom = [
                  #   discordUserId
                  # ];
                  autoJoin = [
                    {
                      inherit guildId;
                      channelId = "1472133243997524013";
                    }
                  ];
                  daveEncryption = true;
                  decryptionFailureTolerance = 24;
                  tts = {
                    provider = "elevenlabs";
                    providers.elevenlabs = { };
                  };
                };
                autoPresence = {
                  enabled = true;
                  intervalMs = 30000;
                  minUpdateIntervalMs = 15000;
                  healthyText = "";
                  degradedText = "Flagging";
                  exhaustedText = "Exhausted ({reason})";
                };
                execApprovals = {
                  enabled = true;
                };
                ackReaction = "🌀";
              };
          };

          talk = {
            provider = "elevenlabs";
            providers.elevenlabs = { };
          };

          messages.tts = {
            enabled = true;
            provider = "elevenlabs";
            providers.elevenlabs = { };
          };

          tools = {
            web = {
              search = {
                enabled = true;
                openaiCodex = {
                  enabled = true;
                  mode = "cached";
                  # allowedDomains = [ "example.com" ];
                  contextSize = "high";
                  userLocation = {
                    country = "US";
                    city = "New York";
                    timezone = "America/New_York";
                  };
                };

                # Empty means autodetect and autofallback.
                # provider = "brave";
                maxResults = 5;
                timeoutSeconds = 30;
              };
            };
          };

          commands = {
            native = "auto";
            nativeSkills = "auto";
            text = true;
            bash = false;
            bashForegroundMs = 2000;
            config = false;
            mcp = false;
            plugins = false;
            debug = false;
            restart = true;
            ownerAllowFrom = [ "discord:${discordUserId}" ];
            ownerDisplay = "raw";
            # ownerDisplaySecret = "\${OWNER_ID_HASH_SECRET}";
            # allowFrom = {
            #   discord = [ "user:${discordUserId}" ];
            # };
            # useAccessGroups = true;
          };

          skills = {
            entries = {
              agentmail = {
                enabled = true;
              };
            };
          };

          plugins = {
            entries = {
              openai = {
                enabled = true;
              };
              voice-call = {
                enabled = true;
                config = { };
              };
              memory-core = {
                config = {
                  dreaming = {
                    enabled = true;
                    timezone = "America/New_York";
                  };
                };
              };
            };
          };
        };
    };
  };

  systemd.user.services.openclaw-gateway = {
    Service.EnvironmentFile = "${config.home.homeDirectory}/.openclaw-secrets/env";
  };
}
