{ config, pkgs }:

{
  home.file = {
    "${config.xdg.configHome}/wezterm/wezterm.lua" = {
      recursive = true;
      text = ''
      local wezterm = require 'wezterm'
      return {
        font = wezterm.font 'MesloLGS Nerd Font',
        color_scheme = 'Srcery (Gogh)',
      }
      '';
    };
  };
}
