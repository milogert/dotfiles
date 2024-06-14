{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.hack-font;
      name = "Hack";
      size = 10;
    };

    keybindings = {};

    settings = {
      tab_bar_style = "hidden";
      confirm_os_window_close = 0;
    };

    theme = "srcery";
  };
}
