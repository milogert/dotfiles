{ pkgs, ... }:

let
  modifier = "Mod1";
  volsink = "0";
  volchange = "5";
in {
  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    wofi
    #dmenu
  ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod1";

      assigns = {
        "1: browser" = [
          { class = "^Firefox"; }
        ];
      };

      floating.criteria = [
        { title = "Steam - Update News"; }
        { class = "Pavucontrol"; }
      ];

      keybindings = {
        "${modifier}+Shift+r" = "restart";
        "Ctrl+Shift+4" = "grim -g \"$(slurp)\" $(xdg-user-dir PICTURES)/screenshots/$(date +'screenshot_%Y-%m-%dT%H:%M:%S.png')";
        "${modifier}+Shift+w" = "mkdir -p ~/Pictures/saved_wallpapers; cp ~/.config/sway/wallpaper.jpg ~/Pictures/saved_wallpapers/$(date --iso=seconds).jpg";

        # Media controls
        XF86AudioPlay = "playerctl play";
        XF86AudioPause = "layerctl pause";
        XF86AudioNext = "playerctl next";
        XF86AudioPrev = "playerctl previous";
        XF86AudioRaiseVolume = "pactl set-sink-volume ${volsink} +${volchange}%";
        XF86AudioLowerVolume = "pactl set-sink-volume ${volsink} -${volchange}%";
        XF86AudioMute = "pactl set-sink-mute ${volsink} toggle";

        # Modes
        "${modifier}+Shift+e" = "mode $mode_power";
        "${modifier}+Escape" = "mode $mode_passthrough";
        "${modifier}+g" = "mode $mode_launcher";
        "${modifier}+r" = "mode $mode_resize";
      };

      modes = {};

      output = {
        DP-1 = {
          position = "0,0";
          scale = "2";
        };
      };

      startup = [
        { command = "firefox"; }
        { command = "discord"; }
      ];

      terminal = "kitty";

      window = {
        border = 2;
      };

      workspaceAutoBackAndForth = true;

      bars = [
        {
          id = "top";
          command = ''
            \${pkgs.waybar}/bin/waybar \
              -c ~/.config/waybar/top/config \
              -s ~/.config/waybar/style.css
          '';
        }
        {
          id = "bottom";
          command = ''
            \${pkgs.waybar}/bin/waybar \
              -c ~/.config/waybar/bottom/config \
              -s ~/.config/waybar/style.css
          '';
        }
      ];
    };
  };
}
