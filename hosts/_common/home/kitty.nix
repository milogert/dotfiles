{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
    ];
  };
in {
  programs.kitty = {
    enable = true;

    /* font = { */
    /*   package = nerdfonts; */
    /*   name = "MesloLGS Nerd Font Mono"; */
    /*   size = 11; */
    /* }; */
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
      size = 11;
    };

    keybindings = {};

    settings = {
      tab_bar_style = "hidden";
    };

    theme = "Srcery";
  };
}
