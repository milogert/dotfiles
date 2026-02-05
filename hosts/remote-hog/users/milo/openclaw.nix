{ config, pkgs, lib, ... }:

{
  programs.openclaw = {
    enable = true;

    documents = ~/openclaw;

    config = {
      gateway = {
        mode = "local";
        auth = {
          # Change me
          token = "some funky token";
        };
      };

      channels.telegram = {
        tokenFile = "/run/agenix/telegram-bot-token";
        allowFrom = [7302602201];
      };
    };

    instances.default = {
      enable = true;
      package = pkgs.openclaw;
      stateDir = "~/.data/openclaw";
      workspaceDir = "~/.data/openclaw/workspace";
      gatewayPort = 18790;
    };

    plugins = [
      { source = "github:openclaw/nix-steipete-tools?dir=tools/summarize"; }
      { source = "github:openclaw/nix-steipete-tools?dir=tools/oracle"; }
      # { source = "github:openclaw/nix-steipete-tools?dir=tools/peekaboo"; }
    ];
  };
}
