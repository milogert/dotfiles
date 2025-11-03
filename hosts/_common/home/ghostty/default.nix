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
      theme = "srcery";
      font-size = 11;
      font-family = "Hack Nerd Font Mono";
      font-thicken = true;
      font-thicken-strength = 0;
      inherit custom-shader;
    };
  };

  home.file."${config.xdg.configHome}/ghostty/shaders" = {
    recursive = true;
    source = ./shaders;
  };
}
