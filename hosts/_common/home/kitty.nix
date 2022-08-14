{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
    ];
  };
in {
  programs.kitty = {
    enable = false;

    font = {
      package = nerdfonts;
      name = "MesloLGS Nerd Font Mono";
      size = 11;
    };

    keybindings = {};

    settings = {
      tab_bar_style = "hidden";
    };

    theme = "Srcery";
  };

  home.file."Applications/kitty.app" = {
    recursive = true;
    source = pkgs.kitty + /Applications/kitty.app;
  };
}
