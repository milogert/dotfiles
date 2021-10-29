{ pkgs, ... }:

let
  extraPackages = pkgs.callPackage ./custom-packages.nix {};
in {
  services.home-assistant = {
    enable = false;
    openFirewall = true;
    package = pkgs.home-assistant.override {
      extraPackages = ps: [
        ps.pyipp
        ps.spotipy
        # extraPackages.pylitterbot
        # extraPackages.pyeconet
      ];
    };

    configWritable = true;
    lovelaceConfigWritable = true;

    config = {
      default_config = {};
      met = {};
    };
  };
}
