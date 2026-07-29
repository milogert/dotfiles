{ config, lib, pkgs, ... }:

let
  modifier = "Mod4";
  volsink = "0";
  volchange = "5";

  waybar_bin = "${pkgs.waybar}/bin/waybar";
  waybar_location = "~/.config/waybar";
  waybar_css = "${waybar_location}/style.css";

  # Modes.
  mode_launcher = "launcher";
  mode_passthrough = "passthrough";
  mode_resize = "resize";
  mode_system = "(l)ock, (q)uit sway, (r)eboot, (s)uspend, (p)oweroff, or escape";

  keybindings = lib.mkOptionDefault {
    "${modifier}+Shift+r" = "restart";
    "Ctrl+Shift+4" = "exec --no-startup-id grim -g \"$(slurp)\" $(xdg-user-dir PICTURES)/screenshots/$(date +'screenshot_%Y-%m-%dT%H:%M:%S.png')";
    "${modifier}+Shift+w" = "exec --no-startup-id mkdir -p ~/Pictures/saved_wallpapers; cp ~/.config/sway/wallpaper.jpg ~/Pictures/saved_wallpapers/$(date --iso=seconds).jpg";
    "${modifier}+Shift+s" = "sticky toggle";

    # Modes
    "${modifier}+Escape" = "mode ${mode_passthrough}";
    "${modifier}+g" = "mode ${mode_launcher}";
    "${modifier}+r" = "mode ${mode_resize}";
    "${modifier}+Shift+e" = "mode '${mode_system}'";
    # "${modifier}+d" = "exec fuzzel";
    "${modifier}+d" = "exec ${pkgs.centerpiece}/bin/centerpiece";

    # Media controls
    XF86AudioPlay = "exec --no-startup-id playerctl play-pause";
    XF86AudioPause = "exec --no-startup-id playerctl pause";
    XF86AudioNext = "exec --no-startup-id playerctl next";
    XF86AudioPrev = "exec --no-startup-id playerctl previous";
    XF86AudioRaiseVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${volchange}%";
    XF86AudioLowerVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${volchange}%";
    XF86AudioMute = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

    # Power buttons
    # XF86PowerOff 
  };

  swaylockCommand = "${pkgs.swaylock}/bin/swaylock";

  black = "#1C1B19";
  blue = "#2C78BF";
  bright_black = "#918175";
  bright_blue = "#68A8E4";
  bright_cyan = "#53FDE9";
  bright_green = "#98BC37";
  bright_magenta = "#FF5C8F";
  bright_orange = "#FF8700";
  bright_red = "#F75341";
  bright_white = "#FCE8C3";
  bright_yellow = "#FED06E";
  cyan = "#0AAEB3";
  green = "#519F50";
  hard_black = "#121212";
  magenta = "#E02C6D";
  orange = "#D75F00";
  red = "#EF2F27";
  white = "#D0BFA1";
  xgray1 = "#262626";
  xgray2 = "#303030";
  xgray3 = "#3A3A3A";
  xgray4 = "#444444";
  xgray5 = "#4E4E4E";
  yellow = "#FBB829";
in {
  # home.file."${config.xdg.configHome}/fuzzel/fuzzel.ini".text = ''
  #   dpi-aware=no
  #   icon-theme=Papirus-Dark
  #   width=50
  #   prompt="❯   "
  #   font=Hack:weight=bold:size=20
  #   line-height=30
  #   fields=name,generic,comment,categories,filename,keywords
  #   terminal=zsh -c
  #   layer=overlay
  #   horizontal-pad=0
  #   vertical-pad=0
  #
  #   [colors]
  #   background=${black}ee
  #   border=${hard_black}ee
  #   match=${bright_red}ee
  #   selection-text=${bright_white}ee
  #   selection=${bright_black}ee
  #   text=${white}ee
  #
  #   [border]
  #   radius=10
  #
  #   [dmenu]
  #   exit-immediately-if-empty=yes
  # '';

  home.packages = with pkgs; [
    centerpiece
    # fuzzel
    pango
    pavucontrol
    playerctl
    pulseaudio
    swaybg
    swayidle
    swaylock
    wl-clipboard
    wofi
    python3
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      inherit modifier;

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
        {
          app_id = "firefox";
          title="^Picture-in-Picture$";
        }#border none, floating enable, sticky enable
      ];

      fonts = {
        names = [ "Hack" ];
        style = "Regular";
        size = 10.0;
      };

      input = {
        "type:keyboard" = {
          repeat_delay = "200";
          repeat_rate = "30";
        };

        "*" = {
          natural_scroll = "enabled";
        };
      };

      inherit keybindings;

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
          "${modifier}+Shift+e" = "mode default";

          l = "exec ${swaylockCommand} & swaymsg mode default";
          q = "exit";
          r = "exec swaymsg mode default & systemctl reboot";
          p = "exec swaymsg mode default & systemctl poweroff now";
          s = "exec ${swaylockCommand} & swaymsg mode default & systemctl suspend";
        };
      };

      output = {
        DP-2 = {
          position = "0,0";
          scale = "1";
          # scale = "1.5";
          # scale = "2";
          # bg = "~/wallpaper.jpeg fill";
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

      gaps = {
        # horizontal = 5;
        # vertical = 5;
        inner = 10;
      };

      workspaceAutoBackAndForth = true;

      bars = [
        {
          id = "bar";
          command = "${pkgs.waybar}/bin/waybar";

          fonts = {
            names = [ "Hack" ];
            style = "Regular";
            size = 14.0;
          };

          # colors = {
          #   background = black;
          #   statusline = white;
          #   separator = white;
          #
          #   focusedWorkspace = {
          #     border = bright_black;
          #     background = xgray3;
          #     text = yellow;
          #   };
          #
          #   activeWorkspace = {
          #     border = xgray3;
          #     background = xgray3;
          #     text = bright_black;
          #   };
          #
          #   inactiveWorkspace = {
          #     border = xgray3;
          #     background = xgray1;
          #     text = bright_black;
          #   };
          #
          #   urgentWorkspace = {
          #     border = red;
          #     background = red;
          #     text = black;
          #   };
          #
          #   bindingMode = {
          #     border = magenta;
          #     background = magenta;
          #     text = bright_white;
          #   };
          # };
        }
      ];
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = swaylockCommand; }
      { event = "lock"; command = "lock"; }
    ];

    timeouts = [
      { timeout = 60 * 5; command = swaylockCommand; }
      { timeout = 60 * 15; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };

  services.swaync = {
    enable = true;

    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";

      positionX = "right";
      positionY = "top";
      control-center-positionX = "none";
      control-center-positionY = "none";
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-width = 500;
      control-center-height = 600;
      fit-to-screen = false;

      layer = "overlay";
      control-center-layer = "overlay";
      cssPriority = "user";
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-inline-replies = true;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];

      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = false;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
  };

  programs.swaylock = {
    enable = true;

    settings = {
      show-failed-attempts = true;
      daemonize = true;

      color = "1C1B19";
      inside-color = "D0BFA1"; # white
      inside-clear-color = "2C78BF"; # blue
      inside-ver-color = "FBB829"; # yellow
      inside-wrong-color = "EF2F27"; # red
      key-hl-color = "FF8700";
      ring-color = "FCE8C3";
      ring-clear-color = "68A8E4";
      ring-ver-color = "FED06E";
      ring-wrong-color = "F75341";
      text-clear-color = "1C1B19";
      text-ver-color = "1C1B19";
      text-wrong-color = "1C1B19";
    };
  };
}
