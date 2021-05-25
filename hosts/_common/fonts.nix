{ pkgs, ... }:

let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Meslo"
      #"Hack"
      #"Hasklig"
      "Lilex"
      #"SpaceMono"
    ];
  };
in {
  fonts = {
    enableFontDir = true;
    fonts = [
      nerdfonts
    ];
  };
}
