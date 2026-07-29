{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;

  shaders = ./shaders;

  convertShaderNames = path: "./shaders/" + builtins.baseNameOf path;

  custom-shader = lib.pipe shaders [
    lib.fileset.toList
    (builtins.map convertShaderNames)
  ];
in
{
  home.packages =
    if isDarwin then
      [
        pkgs.ghostty-bin
      ]
    else
      [ ];

  programs.ghostty = {
    enable = true;

    # This is because ghostty is weird on darwin.
    package = if isDarwin then null else pkgs.ghostty;

    enableZshIntegration = true;

    # installBatSyntax = true;
    # installVimSyntax = true;

    settings = {
      clipboard-read = "allow";
      confirm-close-surface = false;
      font-family = "Hack Nerd Font Mono";
      font-size = 12;
      font-thicken = true;
      font-thicken-strength = 0;
      inherit custom-shader;
      link-previews = true;
      link-url = true;
      maximize = true;
      theme = "srcery-3";
    };

    themes = {
      srcery-3 = {
        palette = [
          "0=#121110"
          "1=#ef2f27"
          "2=#519f50"
          "3=#fbb829"
          "4=#2c78bf"
          "5=#e02c6d"
          "6=#0aaeb3"
          "7=#c5b088"
          "8=#917e6b"
          "9=#f75341"
          "10=#98bc37"
          "11=#fed06e"
          "12=#68a8e4"
          "13=#ff5c8f"
          "14=#2be4d0"
          "15=#fce8c3"
        ];
        background = "#121110";
        foreground = "#fce8c3";
        cursor-color = "#fed06e";
        selection-background = "#fce8c3";
        selection-foreground = "#121110";
      };
    };
  };

  home.file."${config.xdg.configHome}/ghostty/shaders" = {
    recursive = true;
    source = ./shaders;
  };
}
