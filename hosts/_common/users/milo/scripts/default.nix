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
    "${config.home.homeDirectory}/.local/bin/gh-notify" = {
      source = ./gh-notify;
      executable = true;
    };
    "${config.home.homeDirectory}/.local/bin/gh-notify.py" = {
      source = ./gh-notify.py;
      executable = true;
    };
    "${config.home.homeDirectory}/.local/bin/gh-notify-watch" = {
      source = ./gh-notify-watch;
      executable = true;
    };
  };
}
