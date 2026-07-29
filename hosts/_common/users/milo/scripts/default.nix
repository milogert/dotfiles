{ config, ... }:

{
  home.file = {
    "${config.home.homeDirectory}/.local/bin/init-flake" = {
      source = ./init-flake;
      executable = true;
    };
    "${config.home.homeDirectory}/.local/bin/mem-sparkline" = {
      source = ./mem-sparkline;
      executable = true;
    };
  };
}
