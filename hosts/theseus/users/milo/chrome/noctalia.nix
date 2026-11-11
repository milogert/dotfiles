{ config, lib, ... }:

let
  makeWorkspaceKeybinds =
    ni:
    let
      n = builtins.toString ni;
    in
    ''
      "Mod+${n}" = "workspace-switch:${n}"
      "Mod+Shift+${n}" = "window-move-to-workspace-silent:${n}"
      #"Mod+Shift+${n}" = "window-move-to-workspace:${n}"
    '';

  workspaceKeybinds = lib.strings.join "\n" (
    builtins.map makeWorkspaceKeybinds [
      1
      2
      3
      4
      5
      6
      7
      8
      9
    ]
  );

  makeWindowMovementKeybinds = { bind, direction }: ''
    "Mod+${bind}" = "window-focus-${direction}"
    "Mod+Shift+${bind}" = "${
      if direction == "left" || direction == "right" then
        "column-move-${direction}"
      else
        "window-move-${direction}"
    }"
  '';

  windowMovementKeybinds = lib.strings.join "\n" (
    builtins.map makeWindowMovementKeybinds [
      { bind = "left"; direction = "left"; }
      { bind = "down"; direction = "down"; }
      { bind = "up"; direction = "up"; }
      { bind = "right"; direction = "right"; }
      { bind = "h"; direction = "left"; }
      { bind = "j"; direction = "down"; }
      { bind = "k"; direction = "up"; }
      { bind = "l"; direction = "right"; }
    ]
  );

  keybinds = ''
    # Applications and session
    # "Mod+Return" = { action = "spawn:kitty", repeat = false }
    "Mod+Return" = { action = "spawn:ghostty", repeat = false }
    # "Mod" = "spawn:noctalia msg panel-toggle launcher"
    "Mod+Space" = "spawn:noctalia msg panel-toggle launcher"
    "Mod+Q" = { action = "window-close", repeat = false }
    "Mod+Escape" = "session-quit"
    "Mod+Shift+Escape" = { action = "shortcuts-inhibit-toggle", allow_when_inhibited = true, repeat = false }
    # "Mod+Shift+/" = "cheatsheet-toggle"

    # Media, volume and brightness keys from any input device, routed through the
    # Noctalia shell so its OSDs show. Safe while the session is locked.
    # https://docs.noctalia.dev/noctalia/compositor-settings/umbriel
    "XF86AudioRaiseVolume" = { action = "spawn:noctalia msg volume-up", allow_when_locked = true }
    "XF86AudioLowerVolume" = { action = "spawn:noctalia msg volume-down", allow_when_locked = true }
    "XF86AudioMute" = { action = "spawn:noctalia msg volume-mute", allow_when_locked = true, repeat = false }
    "XF86AudioPlay" = { action = "spawn:noctalia msg media toggle", allow_when_locked = true, repeat = false }
    "XF86AudioNext" = { action = "spawn:noctalia msg media next", allow_when_locked = true }
    "XF86AudioPrev" = { action = "spawn:noctalia msg media previous", allow_when_locked = true }
    "XF86MonBrightnessUp" = { action = "spawn:noctalia msg brightness-up", allow_when_locked = true }
    "XF86MonBrightnessDown" = { action = "spawn:noctalia msg brightness-down", allow_when_locked = true }

    # Focus and movement
    ${windowMovementKeybinds}
    "Mod+F1" = "window-focus-next"

    # Window state and layout
    "Mod+T" = { action = "window-toggle-floating", repeat = false }
    "Mod+Shift+T" = { action = "window-focus-switch-floating", repeat = false }
    "Mod+P" = { action = "window-toggle-pinned", repeat = false }
    "Mod+M" = { action = "window-toggle-maximize-to-edges", repeat = false }
    "Mod+F" = { action = "window-toggle-fullscreen", repeat = false }
    "Mod+Ctrl+F" = { action = "window-toggle-maximize", repeat = false }
    "Mod+R" = "window-cycle-primary-extent"
    "Mod+Shift+R" = "window-cycle-primary-extent-back"
    "Mod+Comma" = "window-consume-left"
    "Mod+Period" = "window-consume-right"
    "Mod+Ctrl+Comma" = "window-consume-from-left"
    "Mod+Ctrl+Period" = "window-consume-from-right"
    # Needs layout.mode = "dwindle".
    # "Mod+Alt+T" = "layout-toggle-split"
    "Mod+W" = { action = "column-toggle-tabbed", repeat = false }
    "Mod+Alt+Right" = "column-focus-tab-next"
    "Mod+Alt+Left" = "column-focus-tab-previous"
    "Mod+WheelUp" = "window-focus-left"
    "Mod+WheelDown" = "window-focus-right"
    "Mod+O" = { action = "overview-toggle", repeat = false }

    # Workspaces
    # Move the whole workspace, retaining its name, layout, and windows.
    # "Mod+Ctrl+Page_Down" = "workspace-move-to-output-next"
    # "Mod+Ctrl+Page_Up" = "workspace-move-to-output-previous"
    # "Mod+Ctrl+W" = "workspace-move-to-output current WEB --output DP-1"
    ${workspaceKeybinds}

    # Scratchpad
    "Mod+Shift+S" = { action = "window-move-to-scratchpad", repeat = false }
    "Mod+S" = "scratchpad-toggle"
    "Mod+Ctrl+S" = { action = "window-restore-from-scratchpad", repeat = false }
    "Mod+Tab" = "scratchpad-focus-next"

  '';
in
{
  programs.noctalia = {
    enable = true;

    settings = {
      wallpaper = {
        enabled = true;
        default.path = "/path/to/wallpapers/wallpaper.png";
      };

      dock = {
        enabled = true;
        smart_auto_hide = true;
      };

      location = {
        auto_locate = true;
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@DP-2" ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget."lockscreen-login-box@DP-2" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 2560.0;
          cy = 1318.666748046875;
          output = "DP-2";
          placement_height = 1440.0;
          placement_width = 5120.0;
          rotation = 0.0;
          type = "login_box";

          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
      };

      shell = {
        launcher = {
          app_grid = true;
        };

        panel = {
          launcher_placement = "attached";
        };
      };

      theme = {
        builtin = "Gruvbox";
        mode = "auto";
        source = "builtin";
      };

      weather = {
        unit = "imperial";
      };
    };
  };

  home.file."${config.xdg.configHome}/umbriel/config.toml".text = ''
    [output.DP-2]
    mode = "7680x2160@120"
    position = [0, 0]
    scale = 1
    focus_at_startup = true

    [layout]
    mode = "dwindle"

    [workspaces]
    back_and_forth = true

    [keybinds]
    ${keybinds}

    [input.keyboard]
    layout = ""           # empty uses the system keymap
    variant = ""
    options = ""
    model = ""
    repeat_rate = 25
    repeat_delay = 225
    numlock_toggle = true
    track_layout = "global"

    [input.mouse]
    natural_scroll = true
  '';
}
