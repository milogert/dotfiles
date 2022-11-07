{ pkgs, ... }:

{
  imports = [
    ../alacritty.nix
    ../browserpass.nix
    ../kitty.nix
    /* ../ranger.nix */
    ../wezterm.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
