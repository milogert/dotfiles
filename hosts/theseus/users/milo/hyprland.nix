{pkgs, ... }:

let
  workspaces = [1 2 3 4 5];

  mkWorkspaceBinds = workspace:
    let
      wsString = builtins.toString workspace;
    in [
      "$mod, ${wsString}, workspace, ${wsString}"
      "$mod SHIFT, ${wsString}, movetoworkspace, ${wsString}"
      # "$mod ALT SHIFT, ${wsString}, movetoworkspaceslient, ${wsString}"
    ];
in {

  home.packages = with pkgs; [
    # centerpiece
    # # fuzzel
    # pango
    # pavucontrol
    # playerctl
    # pulseaudio
    # swaybg
    # swayidle
    # swaylock
    # wl-clipboard
    # wofi
    # python3

    cava
    dunst
    fish
    grim
    # hyprland-git
    # jq
    kitty
    # pokemon-colorscripts-git
    python3
    # rustup
    slurp
    # starship
    # swaylock-effects
    # swaylockd
    swww
    tty-clock
    # waybar-hyprland-git
    waybar-mpris
    wl-clipboard
    xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    # package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    settings = {
      decoration = {
        # shadow_offset = "0 5";
        # "col.shadow" = "rgba(00000099)";
        drop_shadow = true;
        shadow_range = 100;
        shadow_render_power = 5;
        "col.shadow" = "0x33000000";
        "col.shadow_inactive" = "0x22000000";
        rounding = 15;
      };

      "$mod" = "SUPER";
      "$terminal" = "${pkgs.wezterm}/bin/wezterm";

      monitor = [
        #"DP-1,7680x2160@120,0x0,1,bitdepth,10"#,vrr,true"
        ",preferred,auto,auto,vrr,2"
      ];

      exec-once = [
        "$terminal"
        "${pkgs.waybar}/bin/waybar"
      ];

      bind = [
        "$mod, q, killactive"
        "$mod SHIFT, t, exec, /etc/profiles/per-user/milo/bin/kitty"
        "$mod SHIFT, b, exec, firefox"
        "$mod ALT SHIFT, Q, exit"
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, j, swapwindow, d"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, l, swapwindow, r"
        "$mod, s, togglefloating"
        "$mod, space, exec, wofi --show drun"
        "$mod SHIFT, l, exec, hyprlock"
        "$mod, z, fullscreen, 0"
      ] ++ builtins.concatMap mkWorkspaceBinds workspaces;

      general = {
        layout = "master";
        sensitivity = 1.0; # for mouse cursor    
        gaps_in = 8;
        gaps_out = 15;
        border_size = 3;
        "col.active_border" = "rgba(cba6f7ff) rgba(89b4faff) rgba(94e2d5ff) 10deg";
        "col.inactive_border" = "0xff45475a";
        apply_sens_to_raw = 0; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
        # "col.group_border" = "0xff89dceb";
        # "col.group_border_active" = "0xfff9e2af";
      };

      input = {
        sensitivity = 1.0;
        natural_scroll = true;
        repeat_rate = 75;
        repeat_delay = 300;
      };

      windowrule = [
        # example window rules
        # for windows named/classed as abc and xyz
        #move 69 420,abc
        "move center,title:^(fly_is_kitty)$"
        "size 800 500,title:^(fly_is_kitty)$"
        "animation slide,title:^(all_is_kitty)$"
        "float,title:^(all_is_kitty)$"
        #tile,xy
        "tile,title:^(kitty)$"
        "float,title:^(fly_is_kitty)$"
        "float,title:^(clock_is_kitty)$"
        "size 418 234,title:^(clock_is_kitty)$"
        #pseudo,abc
        #monitor 0,xyz
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bezier = [
        # "overshot,0.05,0.9,0.1,1.1"
        "overshot,0.13,0.99,0.29,1.1"
      ];

      animation = [
        # "enabled=1"
        "windows,1,4,overshot,slide"
        "border,1,10,default"
        "fade,1,10,default"
        "workspaces,1,6,overshot,slidevert"
      ];

      # Layouts
      master = {
        orientation = "center";
        mfact = 0.5;
      };
    };

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  programs.wofi = {
    enable = true;

    settings = {
      width = 400;
      height = 250;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };

    style = ''
      window {
          margin: 0px;
          border: 5px solid #f5c2e7;
          background-color: #f5c2e7;
          border-radius: 15px;
      }

      #input {
          padding: 4px;
          margin: 4px;
          padding-left: 20px;
          border: none;
          color: #fff;
          font-weight: bold;
          background-color: #fff;
          background: linear-gradient(90deg, rgba(203,166,247,1) 0%, rgba(245,194,231,1) 100%);
          outline: none;
          border-radius: 15px;
          margin: 10px;
          margin-bottom: 2px;
      }
      #input:focus {
          border: 0px solid #fff;
          margin-bottom: 0px;
      }

      #inner-box {
          margin: 4px;
          border: 10px solid #fff;
          color: #cba6f7;
          font-weight: bold;
          background-color: #fff;
          border-radius: 15px;
      }

      #outer-box {
          margin: 0px;
          border: none;
          border-radius: 15px;
          background-color: #fff;
      }

      #scroll {
          margin-top: 5px;
          border: none;
          border-radius: 15px;
          margin-bottom: 5px;
          /* background: rgb(255,255,255); */
      }

      #text:selected {
          color: #fff;
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
      }

      #entry {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background-color: transparent;
      }

      #entry:selected {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background: linear-gradient(45deg, rgba(203,166,247,1) 30%, rgba(245,194,231,1) 100%);
      }
    '';
  };

  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
      {
        timeout = 900;
        on-timeout = "hyprlock";
      }
      {
        timeout = 1200;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      ];
    };

  };

  # services.hyprpaper = {
  #   enable = true;
  #   settings = {
  #     ipc = "on";
  #     splash = false;
  #     splash_offset = 2.0;
  #
  #     preload =
  #       [ "/share/wallpapers/buttons.png" "/share/wallpapers/cat_pacman.png" ];
  #
  #     wallpaper = [
  #       "DP-3,/share/wallpapers/buttons.png"
  #         "DP-1,/share/wallpapers/cat_pacman.png"
  #     ];
  #   };
  # };
}
