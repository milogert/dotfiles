{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [
      {
        name = "top";
        position = "top";
        layer = "top";
        height = 21;

        modules-left = [
            "sway/window"
        ];
        modules-center = [
            "clock"
        ];
        modules-right = [
            "network"
            "pulseaudio"
            "battery"
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
        battery = {
            format = "🔋{capacity}% ⏲️{time}";
            format-icons = ["😨" "😬" "🤔" "👌" "💯"];
            states = {
                warning = 25;
                critical = 10;
            };
        };
        clock = {
            format = "{:%Y-%m-%d %H:%M}";
            format-alt = "{:%a; %d. %b  %H:%M}";
        };
};
      }
      {
        name = "bottom";
        position = "bottom";
        layer = "top";
        height = 21;

        modules-left = ["sway/workspaces"];
        modules-center = ["sway/mode"];
        modules-right = [
            "custom/nzbget"
            "custom/disk-root"
            "custom/disk-home"
            "tray"
        ];

modules = {
        "custom/nzbget" = {
            exec-if = "which curl && which jq";
            exec = "~/.config/waybar/bottom/nzbget.sh";
            format = "{}";
            interval = 15;

        };

        "custom/disk-root" = {
            format = "/: {}";
            exec = "df -h --output=target,avail | grep '/ ' | awk '{print $2}'";
        };
        "custom/disk-home" = {
            format = "/home: {}";
            exec = "df -h --output=target,avail | grep '/home' | awk '{print $2}'";
        };
        tray = {};
};
      }
    ];
  };
}
