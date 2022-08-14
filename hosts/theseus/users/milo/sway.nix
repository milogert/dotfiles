{ lib, pkgs, ... }:

let
  modifier = "Mod1";
  volsink = "0";
  volchange = "5";

  workspace1 = "1:www";
  workspace2 = "2:misc";
  workspace3 = "3:tty";
  workspace4 = "4:media";
  workspace5 = "5:chat";
  workspace6 = "6:config";

  waybar_bin = "${pkgs.waybar}/bin/waybar";
  waybar_location = "~/.config/waybar";
  waybar_css = "${waybar_location}/style.css";

  keybindings = lib.mkOptionDefault {
    # Workspace stuff.
    "${modifier}+1" = "workspace ${workspace1}";
    "${modifier}+2" = "workspace ${workspace2}";
    "${modifier}+3" = "workspace ${workspace3}";
    "${modifier}+4" = "workspace ${workspace4}";
    "${modifier}+5" = "workspace ${workspace5}";
    "${modifier}+6" = "workspace ${workspace6}";

    # Workspace movement.
    "${modifier}+Shift+1" = "move container to workspace ${workspace1}";
    "${modifier}+Shift+2" = "move container to workspace ${workspace2}";
    "${modifier}+Shift+3" = "move container to workspace ${workspace3}";
    "${modifier}+Shift+4" = "move container to workspace ${workspace4}";
    "${modifier}+Shift+5" = "move container to workspace ${workspace5}";
    "${modifier}+Shift+6" = "move container to workspace ${workspace6}";

    "${modifier}+Shift+r" = "restart";
    "Ctrl+Shift+4" = "grim -g \"$(slurp)\" $(xdg-user-dir PICTURES)/screenshots/$(date +'screenshot_%Y-%m-%dT%H:%M:%S.png')";
    "${modifier}+Shift+w" = "mkdir -p ~/Pictures/saved_wallpapers; cp ~/.config/sway/wallpaper.jpg ~/Pictures/saved_wallpapers/$(date --iso=seconds).jpg";

    # Modes
    "${modifier}+Escape" = "mode ${mode_passthrough}";
    "${modifier}+g" = "mode ${mode_launcher}";
    "${modifier}+r" = "mode ${mode_resize}";
    "${modifier}+Shift+e" = "mode '${mode_system}'";

    # Media controls
    XF86AudioPlay = "playerctl play";
    XF86AudioPause = "playerctl pause";
    XF86AudioNext = "playerctl next";
    XF86AudioPrev = "playerctl previous";
    XF86AudioRaiseVolume = "pactl set-sink-volume ${volsink} +${volchange}%";
    XF86AudioLowerVolume = "pactl set-sink-volume ${volsink} -${volchange}%";
    XF86AudioMute = "pactl set-sink-mute ${volsink} toggle";
  };

  # Modes.
  mode_launcher = "launcher";
  mode_passthrough = "passthrough";
  mode_resize = "resize";
  mode_system = "(l)ock, (q)uit sway, (r)eboot, (h)ibernate, (s)hutdown, or escape";

  black = "#1C1B19";
  bright_black = "#918175";

  red = "#EF2F27";
  bright_red = "#F75341";

  green = "#519F50";
  bright_green = "#98BC37";

  yellow = "#FBB829";
  bright_yellow = "#FED06E";

  blue = "#2C78BF";
  bright_blue = "#68A8E4";

  magenta = "#E02C6D";
  bright_magenta = "#FF5C8F";

  cyan = "#0AAEB3";
  bright_cyan = "#53FDE9";

  white = "#D0BFA1";
  bright_white = "#FCE8C3";

  orange = "#D75F00";
  bright_orange = "#FF8700";

  xgray1 = "#262626";
  xgray2 = "#303030";
  xgray3 = "#3A3A3A";
  xgray4 = "#444444";
  xgray5 = "#4E4E4E";

  hard_black = "#121212";
in {
  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    pango
    pavucontrol
    wofi
  ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = modifier;

      assigns = {
        "${workspace1}" = [
          { class = "^Firefox"; }
        ];
        "${workspace3}" = [
          { app_id = "Alacritty"; }
        ];
        "${workspace4}" = [
          { class = "Spotify"; }
        ];
        "${workspace5}" = [
          { class = "discord"; }
        ];
        "${workspace6}" = [
          { app_id = ".blueman-manager-wrapped"; }
          { app_id = "pavucontrol"; }
        ];
      };

      colors = {
        focused = {
          border = bright_black;
          background = xgray3;
          text = yellow;
          indicator = yellow;
          childBorder = bright_black;
        };
        focusedInactive = {
          border = xgray3;
          background = xgray3;
          text = bright_black;
          indicator = xgray3;
          childBorder = xgray3;
        };
        unfocused = {
          border = xgray1;
          background = xgray1;
          text = bright_black;
          indicator = xgray1;
          childBorder = xgray1;
        };
        /* urgent           red          xgray1     red          red      red */
        /* placeholder      xgray3       hard_black bright_black xgray3   xgray3 */
        /* background       black */
      };

      floating.criteria = [
        { title = "Steam - Update News"; }
        { class = "Pavucontrol"; }
      ];

      fonts = {
        names = [
          "MesloLGS Nerd Font Mono"
          "Liberation Mono"
        ];
        size = 10.0;
      };

      input = {
        "*" = {
          repeat_delay = "200";
          repeat_rate = "20";
          natural_scroll = "enabled";
        };
      };

      keybindings = keybindings;

      modes = {
        "${mode_launcher}" = {
          Return = "mode default";
          Escape = "mode default";
          "${modifier}+g" = "mode default";
        };

        "${mode_passthrough}" = {
          "${modifier}+Escape" = "mode default";
        };

        "${mode_resize}" = {
          Return = "mode default";
          Escape = "mode default";
          "${modifier}+r" = "mode default";
          h     = "resize shrink width 10 px";
          Left  = "resize shrink width 10 px";
          j     = "resize grow height 10 px";
          Down  = "resize grow height 10 px";
          k     = "resize shrink height 10 px";
          Up    = "resize shrink height 10 px";
          l     = "resize grow width 10 px";
          Right = "resize grow width 10 px";
        };

        "${mode_system}" = {
          Return = "mode default";
          Escape = "mode default";

          l = "swaylock && swaymsg mode default";
          q = "exit";
          r = "systemctl reboot && swaymsg mode default";
          s = "systemctl shutdown && swaymsg mode default";
          h = "systemctl hibernate && swaymsg mode default";
        };
      };

      output = {
        DP-2 = {
          position = "0,0";
          scale = "2";
        };
      };

      startup = [
        { command = "alacritty"; }
        { command = "firefox"; }
        { command = "discord"; }
      ];

      terminal = "alacritty";

      window = {
        border = 2;
      };

      workspaceAutoBackAndForth = true;

      bars = [
        {
          id = "bar";
          command = waybar_bin;

          colors = {
            background = black;
            statusline = white;
            separator = white;

            focusedWorkspace = {
              border = bright_black;
              background = xgray3;
              text = yellow;
            };

            activeWorkspace = {
              border = xgray3;
              background = xgray3;
              text = bright_black;
            };

            inactiveWorkspace = {
              border = xgray3;
              background = xgray1;
              text = bright_black;
            };

            urgentWorkspace = {
              border = red;
              background = red;
              text = black;
            };

            bindingMode = {
              border = magenta;
              background = magenta;
              text = bright_white;
            };
          };
        }
      ];
    };
  };
}
