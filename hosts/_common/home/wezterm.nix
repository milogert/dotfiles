{config, ...}:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        color_scheme = "Srcery (Gogh)",
        font = wezterm.font("Hack"),
        font_size = 11.0,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
