{ config, ... }:

{
  home.file = {
    "${config.home.homeDirectory}/.local/bin/init-flake" = {
      source = ./init-flake;
      executable = true;
    };
  };
}
