{
  config,
  lib,
  # pkgs,
  ...
}:

{
  # home.packages = [
  #   pkgs.slumber
  # ];

  programs.zsh.shellAliases = {
    slumber = "SLUMBER_CONFIG_PATH=${config.xdg.configHome}/slumber/config.yml slumber";
  };

  home.file."${config.xdg.configHome}/slumber/config.yml".text = lib.generators.toYAML { } {
    "input_bindings" = {
      "up" = [ "k" ];
      "down" = [ "j" ];
      "left" = [ "h" ];
      "right" = [ "l" ];
      "scroll_left" = [ "shift h" ];
      "scroll_right" = [ "shift l" ];
    };
  };
}
