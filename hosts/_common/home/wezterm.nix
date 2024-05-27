{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      return {
        font = wezterm.font("Hack"),
        font_size = 11.0,
        color_scheme = "Srcery (Gogh)",
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
