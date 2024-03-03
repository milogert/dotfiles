{ pkgs, ... }:

{
  imports = [
    ../kitty.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
