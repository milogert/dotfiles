{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
    ];
  };
in {
  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.fira-code
      nerdfonts
      pkgs.iosevka
    ];
  };
}
