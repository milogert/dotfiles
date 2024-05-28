{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Hack"
      "FiraCode"
      "Iosevka"
    ];
  };
in {
  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.hack-font
      pkgs.fira-code
      nerdfonts
      pkgs.iosevka
    ];
  };
}
