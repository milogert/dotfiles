{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ lazydocker ];

  home.file."${config.xdg.configHome}/lazydocker/config.yml".text = lib.generators.toYAML { } {
    gui.returnImmediately = true;
    reporting = "off";
  };
}
