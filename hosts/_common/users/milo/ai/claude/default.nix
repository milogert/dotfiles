{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    claude-code
  ];

  home.file."${config.home.homeDirectory}/.claude/settings.json".text = lib.generators.toJSON { } {
    "env" = {
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
    };
    "hooks" = {
      "Stop" = [
        {
          "matcher" = "";
          "hooks" = [
            {
              "type" = "command";
              "command" = "afplay /System/Library/Sounds/Glass.aiff";
            }
            {
              "type" = "command";
              "command" = "tput bel";
            }
            {
              "type" = "command";
              "command" = "/Users/milo/.claude/hooks/peon-ping/peon.sh";
              "timeout" = 10;
            }
          ];
        }
      ];
      "PermissionRequest" = [
        {
          "matcher" = "";
          "hooks" = [
            {
              "type" = "command";
              "command" = "afplay /System/Library/Sounds/Funk.aiff";
            }
            {
              "type" = "command";
              "command" = "tput bel";
            }
            {
              "type" = "command";
              "command" = "/Users/milo/.claude/hooks/peon-ping/peon.sh";
              "timeout" = 10;
            }
          ];
        }
      ];
      "SessionStart" = [
        {
          "matcher" = "";
          "hooks" = [
            {
              "type" = "command";
              "command" = "/Users/milo/.claude/hooks/peon-ping/peon.sh";
              "timeout" = 10;
            }
          ];
        }
      ];
      "UserPromptSubmit" = [
        {
          "matcher" = "";
          "hooks" = [
            {
              "type" = "command";
              "command" = "/Users/milo/.claude/hooks/peon-ping/peon.sh";
              "timeout" = 10;
            }
          ];
        }
      ];
      "Notification" = [
        {
          "matcher" = "";
          "hooks" = [
            {
              "type" = "command";
              "command" = "/Users/milo/.claude/hooks/peon-ping/peon.sh";
              "timeout" = 10;
            }
          ];
        }
      ];
    };
    "statusLine" = {
      "type" = "command";
      "command" = "${config.home.homeDirectory}/.local/bin/claude-status";
    };

    "alwaysThinkingEnabled" = false;
    "model" = "opus";
  };

  home.file = {
    "${config.home.homeDirectory}/.local/bin/" = {
      recursive = true;
      source = ./scripts;
    };
  };
}
