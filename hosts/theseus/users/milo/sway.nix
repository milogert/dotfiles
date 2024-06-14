{ config, lib, pkgs, ... }:

let
  modifier = "Mod4";
  volsink = "0";
  volchange = "5";

  workspaces = [
    { number = "1"; name = "www"; }
    { number = "2"; name = "misc"; }
    { number = "3"; name = "tty"; }
    { number = "4"; name = "media"; }
    { number = "5"; name = "chat"; }
    { number = "6"; name = "config"; }
    { number = "7"; name = "games"; }
  ];

  mkWorkspaceName = { number, name }: "${number}:${name}";

  genWorkspaceName = idx: mkWorkspaceName (builtins.elemAt workspaces idx);

  mkWorkspaceBindings = acc: { number, name }: let
    fullName = mkWorkspaceName { inherit number name; };
  in {
    "${modifier}+${number}" = "workspace ${fullName}";
    "${modifier}+Shift+${number}" =
      "move container to workspace ${fullName}";
  } // acc;

  workspaceBindings = builtins.foldl' mkWorkspaceBindings {} workspaces;

  waybar_bin = "${pkgs.waybar}/bin/waybar";
  waybar_location = "~/.config/waybar";
  waybar_css = "${waybar_location}/style.css";

  keybindings = lib.mkOptionDefault ({
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
  } // workspaceBindings);

  # Modes.
  mode_launcher = "launcher";
  mode_passthrough = "passthrough";
  mode_resize = "resize";
  mode_system = "(l)ock, (q)uit sway, (r)eboot, (s)uspend, (p)oweroff, or escape";

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
  home.file."${config.xdg.configHome}/fuzzel/fuzzel.ini".text = ''
    dpi-aware=no
    icon-theme=Papirus-Dark
    width=50
    prompt="❯   "
    font=Hack:weight=bold:size=20
    line-height=30
    fields=name,generic,comment,categories,filename,keywords
    terminal=zsh -c
    layer=overlay
    horizontal-pad=0
    vertical-pad=0

    [colors]
    background=${black}ee
    border=${hard_black}ee
    match=${bright_red}ee
    selection-text=${bright_white}ee
    selection=${bright_black}ee
    text=${white}ee

    [border]
    radius=10

    [dmenu]
    exit-immediately-if-empty=yes
  '';

  home.packages = with pkgs; [
    # xwayland
    centerpiece
    fuzzel
    mako
    pango
    pavucontrol
    playerctl
    pulseaudio
    swaybg
    swayidle
    swaylock
    wl-clipboard
    wofi
  ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      inherit modifier;

      assigns = {
        "${genWorkspaceName 1}" = [
          { class = "^Firefox"; }
        ];
        "${genWorkspaceName 3}" = [
          { app_id = "Kitty"; }
        ];
        "${genWorkspaceName 5}" = [
          { class = "discord"; }
        ];
        "${genWorkspaceName 6}" = [
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

          l = "swaylock && swaymsg mode default";
          q = "exit";
          r = "systemctl reboot && swaymsg mode default";
          p = "systemctl poweroff now && swaymsg mode default";
          s = "systemctl suspend && swaymsg mode default";
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
        { command = "kitty"; }
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
          id = "bar";
          command = "${pkgs.waybar}/bin/waybar";

          fonts = {
            names = [ "Hack" ];
            style = "Regular";
            size = 10.0;
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
}
