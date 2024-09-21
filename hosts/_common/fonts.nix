{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
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
