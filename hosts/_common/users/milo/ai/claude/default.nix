{
  config,
  lib,
  pkgs,
  ...
}:

let
  directory = "${config.home.homeDirectory}/.claude";
  peonPingScript = "${directory}/hooks/peon-ping/peon.sh";
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  programs.claude-code = {
    enable = true;

    enableMcpIntegration = true;

    settings = {
      env = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      voice = {
        enabled = true;
        mode = "tap";
      };

      hooks = {
        Stop = [
          {
            matcher = "";
            hooks = [
              (
                if isDarwin then
                  {
                    type = "command";
                    command = "afplay /System/Library/Sounds/Glass.aiff";
                  }
                else
                  { }
              )
              {
                type = "command";
                command = "tput bel";
              }
              {
                type = "command";
                command = peonPingScript;
                timeout = 10;
              }
            ];
          }
        ];

        PermissionRequest = [
          {
            matcher = "";
            hooks = [
              (
                if isDarwin then
                  {
                    type = "command";
                    command = "afplay /System/Library/Sounds/Funk.aiff";
                  }
                else
                  { }
              )
              {
                type = "command";
                command = "tput bel";
              }
              {
                type = "command";
                command = peonPingScript;
                timeout = 10;
              }
            ];
          }
        ];

        SessionStart = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = peonPingScript;
                timeout = 10;
              }
              {
                type = "command";
                command = "~/.claude/hooks/ccmux-session-start.sh";
              }
            ];
          }
        ];

        SessionEnd = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = "~/.claude/hooks/ccmux-session-end.sh";
              }
            ];
          }
        ];

        UserPromptSubmit = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = peonPingScript;
                timeout = 10;
              }
            ];
          }
        ];

        Notification = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = peonPingScript;
                timeout = 10;
              }
              {
                type = "command";
                command = "~/.claude/hooks/ccmux-state-notify.sh";
              }
            ];
          }
        ];
      };

      statusLine = {
        type = "command";
        command = ../helpers/ai-harness-status;
      };

      alwaysThinkingEnabled = false;
      model = "claude-sonnet-4-6";
      # Set this to use the 1m context window.
      largeContextWindow = false;

      permissions = {
        allow = [
          "Bash(awk:*)"
          "Bash(find:*)"
          "Bash(gh pr list:*)"
          "Bash(gh search issues:*)"
          "Bash(gh search prs:*)"
          "Bash(grep:*)"
          "Bash(ls:*)"
          "Bash(npm list:*)"
          "Bash(sed:*)"
        ];
      };

      includeCoAuthoredBy = false;
    };

    plugins = {
      ponytail = (
        pkgs.fetchFromGitHub {
          owner = "DietrichGebert";
          repo = "ponytail";
          rev = "16f29800fd2681bdf24f3eb4ccffe38be3baec6b";
          sha256 = "sha256-Y7d4s7uqjH6IbEXhqAiQ+yaxr6iiGcv2X64LuMtG1T8=";
        }
      );
    };
  };

  home.file = {
    "${config.home.homeDirectory}/.local/bin/" = {
      recursive = true;
      source = ./scripts;
    };

    "${directory}/skills/" = {
      recursive = true;
      source = ../skills;
    };
  };
}
