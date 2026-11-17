{ config, lib, ... }:

{
  home.file."${config.xdg.configHome}/ccmux/ccmux.json".text = lib.generators.toJSON { } {
    notifications = {
      enabled = true; # default false (opt-in)
      # events = [
      #   "waiting"
      #   "finished"
      # ]; # default both
      # sound = "Glass"; # false (default) | true (platform default sound) | macOS sound name
      # delayMs = 1000; # debounce for "finished" only; "waiting" always fires immediately
      # backend = "auto"; # "auto" | "ccmux-notifier" | "osascript" | "notify-send" | "dbus" | "osc" | "command";
      # command = "ntfy publish agents \"$CCMUX_TITLE = $CCMUX_BODY\""; # used when backend = "command"
    };
  };
}
