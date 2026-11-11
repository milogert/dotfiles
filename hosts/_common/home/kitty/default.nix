{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  shaders = ./shaders;

  convertShaderNames = path: "./shaders/" + builtins.baseNameOf path;

  custom-shader = lib.pipe shaders [
    lib.fileset.toList
    (builtins.map convertShaderNames)
  ];
in
{
  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;

    font = {
      package = pkgs.hack-font;
      name = "Hack Nerd Font Mono";
      size = 13;
    };

    settings = {
      tab_bar_style = "hidden";
      confirm_os_window_close = 0;
      cursor_trail = 1;
      custom_shaders = "cursor-trail-blaze";
      include = "themes/srcery3.conf";
      paste_actions = "quote-urls-at-prompt,confirm-if-large";
      # This is dangerous, but whatever.
      clipboard_control = "write-clipboard read-clipboard";
    };
  };

  home.file."${config.xdg.configHome}/kitty/themes/srcery3.conf".source = ./themes/srcery3.conf;

  # home.file."${config.xdg.configHome}/ghostty/shaders" = {
  #   recursive = true;
  #   source = ./shaders;
  # };
}
