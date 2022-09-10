{ config, pkgs, ... }:

{
  home.file = {
    "${config.xdg.configHome}/wezterm/wezterm.lua" = {
      recursive = true;
      text = ''
      local wezterm = require 'wezterm'
      return {
        font = wezterm.font 'MesloLGS Nerd Font',
        font_size = 11.3,
        --color_scheme = 'Srcery (Gogh)',

        colors = {
          background = '#1C1B19',
          foreground = '#D0BFA1',
          ansi = {
            '#1C1B19',
            '#EF2F27',
            '#519F50',
            '#FBB829',
            '#2C78BF',
            '#E02C6D',
            '#0AAEB3',
            '#D0BFA1',
            --'#D75F00',
          },
          brights = {
            '#918175',
            '#F75341',
            '#98BC37',
            '#FED06E',
            '#68A8E4',
            '#FF5C8F',
            '#53FDE9',
            '#FCE8C3',
            --'#FF8700',
          },
        },
      }
      '';
    };
  };
}
