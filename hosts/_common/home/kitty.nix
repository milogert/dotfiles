{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
      size = 11;
    };

    keybindings = {};

    settings = {
      tab_bar_style = "hidden";
      confirm_os_window_close = 0;
      background_opacity = ".92";
    };

    theme = "srcery";
  };
}
