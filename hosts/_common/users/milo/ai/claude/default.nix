{
  config,
  lib,
  pkgs,
  ...
}:

let
  directory = "${config.home.homeDirectory}/.claude";
  peonPingScript = "${directory}/hooks/peon-ping/peon.sh";
  inherit (pkgs.stdenv) isDarwin;
in
{
  home.packages = with pkgs; [
    claude-code
  ];

  home.file = {
    "${directory}/settings.json".text = lib.generators.toJSON { } {
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
            ];
          }
        ];
      };

      statusLine = {
        type = "command";
        command = "${config.home.homeDirectory}/.local/bin/claude-status";
      };

      alwaysThinkingEnabled = false;
      model = "claude-sonnet-4-6";
      # Set this to use the 1m context window.
      largeContextWindow = false;
      effort = "medium";

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

    };

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
