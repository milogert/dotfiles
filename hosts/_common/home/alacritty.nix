{ pkgs, ... }:

let
  srceryTheme = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/srcery-colors/srcery-terminal/refs/heads/master/alacritty/srcery_alacritty.toml";
    sha256 = "sha256-OmVM3CyJTcj6hXPJeTeqLJoslbnpneEe50YP+EHg2VE=";
  };
in {
  programs.alacritty = {
    enable = true;

    settings = {
      general.import = [srceryTheme];
      window.option_as_alt = "Both";
      font.normal = {
        family = "Hack Nerd Font Mono";
        style = "Regular";
      };
    };
  };
}
