{ pkgs, ... }:

{
  imports = [
    ../alacritty.nix
    ../browserpass.nix
    ../kitty.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
