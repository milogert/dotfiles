{ pkgs, ... }:

{
  imports = [
    ../kitty.nix
    ../ranger.nix
  ];

  home.packages = with pkgs; [
    /* notion-app-enhanced */
    /* beekeeper-studio */
  ];
}
