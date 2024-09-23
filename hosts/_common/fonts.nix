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
  fonts.packages = [
    pkgs.hack-font
    pkgs.fira-code
    nerdfonts
    pkgs.iosevka
  ];
}
