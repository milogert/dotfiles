{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
    ];
  };
in {
  fonts = {
    fonts = [
      nerdfonts
    ];
  };
}
