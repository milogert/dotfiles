{ pkgs, ... }:

let
in{
  programs.waybar = {
    enable = true;

    settings = [
      {
        position = "top";
        layer = "top";
        # height = 22;

        modules-left = [
          "sway/window"
        ];
        modules-center = [
        ];
        modules-right = [
          "network"
          "pulseaudio"
          "privacy"
          "clock"
        ];

        modules = {
          "sway/window" = {
            max-length = 50;
          };

          network = {
            format-wifi = "{ifname}: {ipaddr}";
            format-ethernet = "{ifname}: {ipaddr}";
            format-disconnected = "down";

            tooltip = true;
            tooltip-format-wifi = "{essid}";
            interval = 15;
          };
          pulseaudio = {
            format = "{icon}{volume}%";
            format-muted = "🔇";
            format-icons = ["🔈" "🔉" "🔊"];
            on-click = "pavucontrol";
          };
          clock = {
            format = "{:%a, %b %d, %I:%M}";
          };
          privacy = {};
        };
      }
      {
        position = "bottom";
        layer = "top";
        # height = 22;

        modules-left = ["sway/workspaces"];
        modules-center = ["sway/mode"];
        modules-right = [
          "disk"
          "temperature"
          "tray"
        ];

        modules = {
          disk = {
            format = "{path}: {free}";
          };
          tray = {
            spacing = 10;
            show_passive_items = true;
          };
          temperature = {};
        };
      }
    ];

    style = builtins.readFile ./style.css;
  };
}
