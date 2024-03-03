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
    packages = [
      pkgs.fira-code
      nerdfonts
      pkgs.iosevka
    ];
  };
}
