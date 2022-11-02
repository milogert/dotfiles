{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in {
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/direnv.nix)
    (common_dir + /home/types/desktop.nix)
  ];

  home.stateVersion = "21.05";

  programs.git.signing = {
    key = "7291258F2B7C086E";
    signByDefault = true;
    gpgPath = "gpg";
  };

  home.packages = with pkgs; [
    discord
    # elixir
    mas
    nodejs
  ];

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs-16_x}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} \
          init-author-name="Milo Gertjejansen" \
          init-author-email="milo@milogert.com" \
          init-author-url="https://milogert.com" \
          init-license="MIT" \
          init-version="0.0.1" \
      '';
}
